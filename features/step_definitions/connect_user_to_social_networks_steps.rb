Given /^I'm logged in$/ do
  UserType.create!(name: "Superuser")
  email = 'user@example.com'
  password = 'password'
  visit '/users/sign_up'
  fill_in 'Name', :with => 'Test organisation'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  fill_in 'Password confirmation', :with => password
  click_on 'Sign up'
end

When /^I visit the user profile$/ do
  find('#account-info').find('a').click
  click_on 'Profile'
end

When /^press the "([^"]*)" authentication connection button$/ do |authentication|
  find('#authentications').find('#' + authentication).find_link('Create Link').click
end

Then /^the page should say "([^"]*)"$/ do |message|
  page.should have_content(message)
end

Then /^the "([^"]*)" authentication should appear as connected$/ do |authentication|
  page.should have_selector('#' + authentication) do |li|
    li.should contain("Connected")
  end
end
