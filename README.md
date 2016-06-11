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
$ gem install nexus
```

## Usage

First we need to create a report. Reports should be placed under `app/reports` and need to inherit from `Nuntius::Report`.

```ruby
class UsersReport < Nuntius::Report

end
```

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
