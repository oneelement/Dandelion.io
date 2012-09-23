source 'http://rubygems.org'

gem 'rails', '3.1.4'

gem "rake"

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem "mongoid", "~> 2.2"
gem "bson_ext", "~> 1.3"
gem 'devise' # Authentication
gem 'cancan'
gem 'acts_as_api'
gem 'omniauth'
gem 'omniauth-linkedin'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem "twitter" #api for twitter
gem 'koala' #api for facebook
gem 'linkedin' 
gem 'google-api-client', :require => 'google/api_client'
gem 'httparty'
gem 'crack'
gem 'json'
#gem 'http_logger'
#gem 'gdata'
#gem 'linkedin', :git => 'http://github.com/pengwynn/linkedin.git', :branch => '2-0-stable'
#api for linkedin

gem "rufus-scheduler", "~> 2.0.17"

gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

gem "rmagick"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails', "  ~> 3.1.0"
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  #gem 'compass', '~> 0.11.0'
  #gem 'compass'
  #gem 'compass-rails', '>= 1.0.0.rc.4'
  #gem 'susy'
  gem 'bootstrap-sass', '~> 2.0.1'
  gem 'jquery-datatables-rails'
end



gem 'jquery-rails'
gem 'backbone-on-rails'

gem "geocoder"

#gem "browser"



# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

gem 'unicorn'

group :development, :test do
  gem "mongrel", "1.2.0.pre2"
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
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  if RUBY_PLATFORM =~ /darwin/i
    gem 'ruby_gntp'
    gem 'autotest-fsevent'
    gem 'autotest-growl'
  end
end
