# A sample Guardfile
# More info at https://github.com/guard/guard#readme

#guard 'coffeescript', :output => 'spec/javascripts/coffee/compiled' do
#    watch('^spec/javascripts/coffee/(.*)\.coffee')
#end
#
#guard 'coffeescript', :output => 'spec/javascripts/coffee/compiled' do
#    watch('^spec/javascripts/coffee/(.*)\.coffee')
#end
#
#guard 'livereload' do
#    watch('^spec/javascripts/.+\.js$')
#end

# Run JS and CoffeeScript files in a typical Rails 3.1 fashion, placing Underscore templates in app/views/*.jst
# Your spec files end with _spec.{js,coffee}.

spec_location = "spec/javascripts/%s_spec"

# uncomment if you use NerdCapsSpec.js
# spec_location = "spec/javascripts/%sSpec"

guard 'jasmine-headless-webkit' do
  watch(%r{^app/views/.*\.jst$})
  watch(%r{^public/javascripts/(.*)\.js$}) { |m| newest_js_file(spec_location % m[1]) }
  watch(%r{^app/assets/javascripts/(.*)\.(js|js\.coffee)$}) { |m| newest_js_file(spec_location % m[1]) }
  watch(%r{^spec/javascripts/(.*)_spec\..*}) { |m| newest_js_file(spec_location % m[1]) }
end

