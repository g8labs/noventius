$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nuntius/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nuntius"
  s.version     = Nuntius::VERSION
  s.authors     = ["Andres Pache"]
  s.email       = ["apache90@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Nuntius."
  s.description = "TODO: Description of Nuntius."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "pg"
end
