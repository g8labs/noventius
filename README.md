# Nuntius

Reporting engine for rails applications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nuntius'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install nuntius
```

## Usage

First we need to create a report. Reports should be placed under `app/reports` and need to inherit from `Nuntius::Report`.

```ruby
class UsersReport < Nuntius::Report

end
```

Then you need to mount the nuntius engine by adding this to the application's config/routes.rb:

```ruby
  mount Nuntius::Engine => '/nuntius'
```

After that you can access an use the reports by navigating to:
`http://localhost:3000/nuntius/reports`

### Query

Reports need to implement the `sql` method, this method should return the SQL query that is going to be performed in the database.

```ruby
class UsersReport < Nuntius::Report

  def sql
    <<-SQL
      SELECT *
      FROM users;
    SQL
  end

end
```

### Columns

By default the columns for the report are inferred based on the columns returned by the query and
treated as strings when it comes to display and sorting.
But you can also define in advance what columns the report will have, **The number of columns
defined needs to match the number of elements for every row of the result**, here is an
example:

```ruby
class UsersReport < Nuntius::Report

  column :id, :integer, label: 'Id', html_options: { rowspan: 2, colspan: 1 }
  column :name, :string,  label: -> { self.name.to_s.humanize  }
  column :created_at, :datetime

end
```

#### Supported types
- string
- integer
- float
- datetime
- date

#### Columns groups

Sometimes we want to group several columns under a common header, this can be done using
columns groups:

 ```ruby
class UsersReport < Nuntius::Report
 
  column :id, :integer, label: 'Id', html_options: { rowspan: 2, colspan: 1 }
  columns_group :offer_1,
                [column(:event_1, :string, label: 'Event_1'),
                 column(:event_2, :string, label: 'Event_2'),
                 column(:event_3, :string, label: 'Event_3')],
                label: 'Offer_1', html_options: { colspan: 3, rowspan: 1, }
 
end
 ```

#### Dynamic columns

There are some columns that might depend on the result of the current query in order to be present,
for this case the `dynamic_columns` helper can be used to generate those.

 ```ruby
class UsersReport < Nuntius::Report
 
  column :id, :integer, label: 'Id', html_options: { rowspan: 2 }
  dynamic_columns :role_users_columns
  column :created_at, :datetime, html_options: { rowspan: 2 }
   
  filter :role_id, :select, option_tags: :roles_for_select

  def roles_for_select
    [Role.all.collect { |role| [role.name, role.id] }, nil]
  end

  def role_users_columns
    return [] unless role_id

    Role.find(role_id).users.map do |user|
      columns_group(:role_user,
                    [column(:id, :integer),
                     column(:name, :integer)])
                    label: "${user.role.name [#{user.name}]}", html_options: { colspan: 2 })
    end
  end
 
 end
 ```

What ever the `role_users_columns` returns will we placed in the columns list in the correct order.

### Filters

Many times, reports need some input from the user. This simple DSL will allow you to add filters in reports easily.

```ruby
class UsersReport < Nuntius::Report

  filter :age, :number, options: { min: 18, max: 100 }

  def sql
    <<-SQL
      SELECT *
      FROM users
      WHERE users.age > {age};
    SQL
  end

end
```

This filter call adds a instance method to the report that will return the user input.

A very important thing to notice is that filter DSL wraps on top off rails input helpers so all of them are supported. Full list here: https://github.com/g8labs/nuntius/blob/master/lib/nuntius/filter.rb#L7

#### Select

The select filter generates a select option using a dropdown.
For this filter you need to provide a method name that when executed returns the
available values for the dropdown.

```ruby
class UsersReport < Nuntius::Report

  filter :role_id, :select, option_tags: :roles_for_select

  def roles_for_select
    [Role.all.collect { |role| [role.name, role.id] }, nil]
  end

end
```

##### Supported formats for values
TODO

##### Supported options
- dependent: This allows to generate selects whose options are dependent from
current selected value from another select. When using this option the only
supported format for the values is a hash.

```ruby
filter :letter, :select, option_tags: :letters_for_select, options: { include_blank: true }
filter :number, :select, option_tags: :numbers_for_select, dependent: :letter, options: { include_blank: 'All' }
filter :symbol, :select, option_tags: :symbols_for_select, dependent: [:letter, :number]

def letters_for_select
  [[:a, :b, :c, :d], nil]
end

def numbers_for_select
  {
    a: [['one', 1],['four', 4], 2],
    b: [2],
    c: [3, 4],
    d: [1, 2, 3]
  }
end

def symbols_for_select
  {
    [:a, 1] => ['$', '%'],
    [:c, 3] => ['@']
  }
end
```

### Nested reports

When the user selects a row its possible to display a new report using data from that row as
filters.
For instance in a report that shows users registrations grouped by month, day or hour, it can be
really helpful that when a user selects a row it shows the registrations for every hour of that
particular day but keeping all other filters.
This can be done using the nested report feature, **only one nested report is supported per report**.

You can customize the options for the nested report by providing either a block or a symbol in the
`:filters` option of the nested report. This method needs to to receive the selected row and can
use the selected filters of the parent report.

```ruby
class UsersReport < Nuntius::Report

  filter :start_time, :datetime
  filter :end_time, :datetime
  filter :group_by, :select, option_tags: :groups_for_select

  validate :start_time, rules: { required: true }, messages: { required: 'Provide an start time' }
  validate :end_time, rules: { required: true }, messages: { required: 'Provide an end time' }

  nest_report UsersReport, filters: :nested_filters, if: -> { group_by.present? && grop_by != 'hour' }

  def nested_filters(selected_row)
    selected_date = DateTime.parse(selected_row[3])
    nested_group, start_time, end_time = if group_by == 'month'
                                           ['day', selected_date.at_beginning_of_month.to_s(:db),
                                            selected_date.at_end_of_month.to_s(:db)]
                                         else
                                           ['hour', selected_date.at_beginning_of_day.to_s(:db),
                                            selected_date.at_end_of_day.to_s(:db)]
                                         end

    filter_params.merge('start_time' => start_time, 'end_time' => end_time,
                        'group_by' => nested_group)
  end

  def groups_for_select
    [[:month, :day, :hour], nil]
  end

end
```

#### Options
- `:filters`: Allows to customize the filters used when creating the nested report.
- `:if`: Used to decide whether or not to enable the nested report.

### Validations
TODO

### Formats

Currently the following formats are supported:
- HTML
- CSV

We have plans on adding JSON in the future.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/g8labs/nuntius.

## Contact
- andres.pache@g8labs.co
- martin.fernandez@g8labs.co
- martin.garcia@g8labs.co
