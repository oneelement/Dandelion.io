# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

#Entering User Types

UserType.find_or_create_by(:name => "Superuser")
UserType.find_or_create_by(:name => "Organisation")
UserType.find_or_create_by(:name => "Entity")
UserType.find_or_create_by(:name => "Consumer")
