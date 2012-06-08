require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.5'
gem 'pg'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem "twitter-bootstrap-rails", ">= 2.0.3"
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem "haml", ">= 3.1.6"

gem "sendgrid"
gem "devise", ">= 2.1.0"
gem "cancan", ">= 1.6.7"
gem "rolify", ">= 3.1.0"
gem "simple_form"

group :test, :development do
  gem "guard", ">= 0.6.2"
  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.0.3"
  gem "guard-livereload", ">= 0.3.0"
  gem "guard-rspec", ">= 0.4.3"
  gem "debugger"

  gem "ffaker"
  gem "awesome_print"
  gem "haml-rails", ">= 0.3.4"
  gem "rspec-rails", ">= 2.10.1"
  gem "shoulda-matchers"
  gem "database_cleaner", ">= 0.7.2"
  gem "factory_girl_rails", ">= 3.3.0"
  gem "email_spec", ">= 1.2.1"

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
