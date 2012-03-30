Given /^I'm logged in$/ do
  email = 'user@example.com'
  password = 'password'
  visit '/users/sign_up'
  consumer = find('#signup-consumer')
  consumer.fill_in 'First name', :with => 'Firstname'
  consumer.fill_in 'Last name', :with => 'Lastname'
  consumer.fill_in 'Email', :with => email
  consumer.fill_in 'Password', :with => password
  consumer.fill_in 'Password confirmation', :with => password
  consumer.click_on 'Sign up'
end

When /^I visit the user profile$/ do
  find('#account-info').find('a').click
  click_on 'Profile'
end

When /^press the "([^"]*)" authentication connection button$/ do |authentication|
  find("#authentication-#{authentication} > a").click
end

Then /^the page should say "([^"]*)"$/ do |message|
  page.should have_content(message)
end

Then /^the "([^"]*)" authentication should appear as connected$/ do |authentication|
  page.should have_selector("#authentication-#{authentication}") do |li|
    li.should contain("Connected")
  end
end
