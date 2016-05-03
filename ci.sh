set -e

# Install bundler
gem install bundler

# Install all app dependencies
bundle install

# Run rubocop
RAILS_ENV=test rubocop .

# Create a new migrate db
RAILS_ENV=test rake app:db:drop app:db:create app:db:schema:load

# Run specs
RAILS_ENV=test rspec spec
