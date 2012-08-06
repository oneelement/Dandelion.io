require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.every '1h' do
  puts 'Ripple Check Starting'
  Contact.update_user_contacts
end 
