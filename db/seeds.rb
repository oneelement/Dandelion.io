# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

contents_section = Section.create({
  :name => "Contents",
  :builder_metadata_attributes => {
    :is_top_level => false,
    :is_standard_section => true
  }
})

premises_section = Section.create({
  :name => 'Premises',
  :builder_metadata_attributes => {
    :is_top_level => true,
    :is_standard_section => true
  }
})

el_section = Section.create({
  :name => "Employer's Liability",
  :builder_metadata_attributes => {
    :is_top_level => true,
    :is_standard_section => true
  }
})

