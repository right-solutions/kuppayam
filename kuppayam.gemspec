$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "kuppayam/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "kuppayam"
  s.version     = Kuppayam::VERSION
  s.authors     = ["kpvarma"]
  s.email       = ["krshnaprsad@gmail.com"]
  s.homepage    = "https://github.com/right-solutions/kuppayam"
  s.summary     = "Kuppayam is a basic UI to starter kit"
  s.description = "A basic UI starter kit - rails engine with useful helpers and bootstrap based UI modules"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "spec/factories/kuppayam/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 5.1.4', '>= 5.1.0'
  
  s.add_dependency 'jquery-rails', '~> 4.3.1', '>= 4.3.0'
  s.add_dependency 'font-awesome-rails', '~> 4.7.0.3', '>= 4.7.0'
  s.add_dependency 'simple-line-icons-rails', '~> 0.1.3', '>= 0.1.0'
  s.add_dependency 'kaminari', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'bootstrap-kaminari-views', "~> 0.0.5"
  
  s.add_dependency 'filesize', "~> 0.1.1"
  # s.add_dependency 'roo', "~> 2.7.0"
  s.add_dependency 'iconv', "~> 1.0"
  # s.add_dependency 'config', '~> 1.0'
  s.add_dependency 'bcrypt', "~> 3.0"
  s.add_dependency "colorize", "~> 0.8"
  s.add_dependency "state_machines", '~> 0.5.0'
  s.add_dependency "state_machines-activerecord", '~> 0.5.0'
  
  s.add_development_dependency 'pry', "~> 0.10.1", ">= 0.10.0"
  s.add_development_dependency 'mysql2', "~> 0.4.4"
  s.add_development_dependency 'carrierwave', "~> 0.10.0", ">= 0.9.0"
  s.add_development_dependency 'mini_magick', "~> 4.8.0", ">= 4.8.0"

  s.add_development_dependency 'rspec-rails', "~> 3.5"
  s.add_development_dependency 'capybara', "~> 2.4.4", ">= 2.4.3"
  s.add_development_dependency 'factory_bot_rails', "~> 4.8.0", ">= 4.4.0"
  s.add_development_dependency 'database_cleaner', "~> 1.6.0", ">= 1.4.1"
  s.add_development_dependency 'shoulda-matchers', "~> 3.1"
end
