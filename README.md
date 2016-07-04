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
filter :role_id, :select, option_tags: :roles_for_select

def roles_for_select
  [Role.all.collect { |role| [role.name, role.id] }, nil]
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

### Validations
TODO

### Columns
TODO

### Formats

Currently the only render format is HTML. We have plans on adding CSV and JSON.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/g8labs/nuntius.

## Contact
- andres.pache@g8labs.co
- martin.fernandez@g8labs.co
- martin.garcia@g8labs.co
