$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'nuntius/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'nuntius'
  s.version     = Nuntius::VERSION
  s.authors     = ['Andres Pache', 'Martin Fernandez']
  s.email       = ['andres.pache@g8labs.co', 'martin.fernandez@g8labs.co']
  s.summary     = 'Reporting engine'
  s.description = 'Reporting engine'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'sprockets-rails', '>= 2.1.4'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.3.6'
  s.add_dependency 'sass-rails', '>= 3.2'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails', '~> 3.4.2'
  s.add_development_dependency 'rubocop'
end
