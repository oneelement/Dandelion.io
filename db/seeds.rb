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

contents_value_question = Question.create({
  :name => "Total contents value",
  :section => contents_section
})

contents_item_section = Section.create({
  :name => "Specified Contents Item",
  :builder_metadata_attributes => {
    :is_top_level => false,
    :is_standard_section => true,
    :repeats => true,
    :repeat_max_instances => 5
  }
})

contents_item_type_question = Question.create({
  :name => "Contents item type",
  :section => contents_item_section
})

contents_item_value_question = Question.create({
  :name => "Contents item value",
  :section => contents_item_section
})

contents_item_section.builder_metadata.suggested_questions << [contents_item_type_question, contents_item_value_question]

contents_section.builder_metadata.suggested_child_sections << contents_item_section

contents_section.builder_metadata.suggested_questions << contents_value_question

premises_section = Section.create({
  :name => 'Premises',
  :builder_metadata_attributes => {
    :is_top_level => true,
    :is_standard_section => true,
    :repeats => true,
    :repeat_max_instances => 5

  }
})

premises_address_question = Question.create({
  :name => "Address",
  :section => premises_section
})

premises_section.builder_metadata.suggested_questions << premises_address_question

premises_section.builder_metadata.suggested_child_sections << contents_section

el_section = Section.create({
  :name => "Employer's Liability",
  :builder_metadata_attributes => {
    :is_top_level => true,
    :is_standard_section => true
  }
})

el_loi_question = Question.create({
  :name => "EL Limit of Indemnity",
  :section => el_section
})

el_section.builder_metadata.suggested_questions << el_loi_question
