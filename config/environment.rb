# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Onelement::Application.initialize!
Rack::Utils.key_space_limit = 123456789 

