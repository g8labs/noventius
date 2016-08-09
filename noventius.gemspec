$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'noventius/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'noventius'
  s.version     = Noventius::VERSION
  s.authors     = ['Andres Pache', 'Martin Fernandez']
  s.email       = ['andres.pache@g8labs.co', 'martin.fernandez@g8labs.co']
  s.homepage    = 'https://github.com/g8labs/nuntius'
  s.license     = 'MIT'
  s.summary     = 'Rails reporting engine'
  s.description = <<-DESC
    Nuntius("A messenger, reporter, courier, bearer of news or tidings") is a reporting engine for the Rails framework.
  DESC

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-tablesorter', '~> 1.21', '>= 1.21.3'
  s.add_dependency 'momentjs-rails', '~> 2.11', '>= 2.11.1'
  s.add_dependency 'moment_timezone-rails', '~> 0.5'
  s.add_dependency 'twitter-bootstrap-rails', '~> 3.2', '>= 3.2.2'
  s.add_dependency 'jquery-validation-rails', '~> 1.13', '>= 1.13'
  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.17', '>= 4.17.37'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails', '~> 3.4.2'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
end
