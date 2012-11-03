require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '~> 3.2.5'
gem 'pg'
gem 'jquery-rails'
gem "haml", ">= 3.1.6"
gem "sendgrid"
gem "devise", ">= 2.1.0"
gem "cancan", ">= 1.6.7"
gem "rolify", ">= 3.1.0"
gem "simple_form"
gem "thin-rails"
gem "spine-rails", git: "git://github.com/maccman/spine-rails.git"
gem "eco"
gem "friendly_id"

gem 'activerecord-postgis-adapter'
gem 'rgeo'
gem 'rgeo-shapefile'
gem 'georuby'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "twitter-bootstrap-rails", "2.1.0"
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem "guard", ">= 0.6.2"
  gem "guard-livereload", ">= 0.3.0"
  gem "guard-coffeescript"
  gem "guard-ctags-bundler"
  gem "guard-rails", git: "git://github.com/johnbintz/guard-rails.git"

  gem "debugger"
  gem "pry"

  gem "fuubar"
  gem "ffaker"
  gem "awesome_print"
  gem "haml-rails", ">= 0.3.4"
  gem "rspec-rails", ">= 2.10.1"
  gem "capybara"
  gem "capybara-firebug"
  gem "shoulda-matchers"
  gem "database_cleaner", ">= 0.7.2"
  gem "factory_girl_rails", ">= 3.3.0"
  gem "fixture_builder"
  gem "email_spec", ">= 1.2.1"
  gem "jasmine"
  gem "jasminerice", git: "git://github.com/dimroc/jasminerice.git"

  case HOST_OS
    when /darwin/i
      gem 'rb-fsevent', :group => :development
      gem 'growl', :group => :development
    when /linux/i
      gem 'libnotify', :group => :development
      gem 'rb-inotify', :group => :development
    when /mswin|windows/i
      gem 'rb-fchange', :group => :development
      gem 'win32console', :group => :development
      gem 'rb-notifu', :group => :development
  end
end
