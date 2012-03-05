source 'http://rubygems.org'

gem 'rails', '3.1.0'


gem "rake" , "0.8.7"

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem "mongoid", "~> 2.2"
gem "bson_ext", "~> 1.3"
gem 'devise' # Authentication
gem 'cancan'
gem 'acts_as_api'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'compass', '~> 0.11.0'
end

gem 'jquery-rails'
gem 'backbone-on-rails'

gem "mongrel", "1.2.0.pre2"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :development, :test do
  gem 'jasmine'
  gem 'jasmine-headless-webkit'
  gem 'jasmine-spec-extras'
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'spork'
  gem 'guard'
  gem 'guard-jasmine-headless-webkit'
  gem 'autotest'
  gem 'autotest-rails-pure'
  if RUBY_PLATFORM =~ /darwin/i
    gem 'ruby_gntp'
    gem 'autotest-fsevent'
    gem 'autotest-growl'
  end
end
