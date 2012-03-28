# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

premises_section = Section.create({
  :name => 'Premises',
  :builder_details_container_attributes => {
    :is_top_level => true,
    :is_standard_section => true,
    :repeats => true,
    :repeat_max_instances => 5

  }
})

premises_address_question = Question.create({
  :name => "Address",
  :question_type => AddressQuestionType.create({}),
  :builder_details_container_attributes => {
    :section => premises_section,
    :is_standard_question => true
  }
})

contents_section = Section.create({
  :name => "Contents",
  :builder_details_container_attributes => {
    :is_top_level => false,
    :is_standard_section => true,
    :section => premises_section
  }
})

contents_value_question = Question.create({
  :name => "Total contents value",
  :question_type => NumericQuestionType.new({
    :decimal_places => 0
  }),
  :builder_details_container_attributes => {
    :section => contents_section,
    :is_standard_question => true
  }
})

contents_item_section = Section.create({
  :name => "Specified Contents Item",
  :builder_details_container_attributes => {
    :is_top_level => false,
    :is_standard_section => true,
    :repeats => true,
    :repeat_max_instances => 5,
    :section => contents_section
  }
})

contents_item_type_computers = PossibleAnswer.create({
  :value => 'Computers'
})
contents_item_type_antiques = PossibleAnswer.create({
  :value => 'Antiques'
})
contents_item_type_other = PossibleAnswer.create({
  :value => 'Other'
})

contents_item_type_group = PossibleAnswerGroup.create({
  :name => 'Contents item types'
})

contents_item_type_group.possible_answers << [contents_item_type_computers, contents_item_type_antiques, contents_item_type_other]

contents_item_type_question = Question.create({
  :name => "Contents item type",
  :question_type => PossibleAnswerQuestionType.create({
    :possible_answer_group => contents_item_type_group
  }),
  :builder_details_container_attributes => {
    :section => contents_item_section,
    :is_standard_question => true
  }
})

contents_item_value_question = Question.create({
  :name => "Contents item value",
  :question_type => NumericQuestionType.new({
    :decimal_places => 0
  }),
  :builder_details_container_attributes => {
    :section => contents_item_section,
    :is_standard_question => true
  }
})

el_section = Section.create({
  :name => "Employer's Liability",
  :builder_details_container_attributes => {
    :is_top_level => true,
    :is_standard_section => true
  }
})

el_loi_question = Question.create({
  :name => "EL Limit of Indemnity",
  :question_type => NumericQuestionType.new({
    :decimal_places => 0
  }),
  :builder_details_container_attributes => {
    :section => el_section,
    :is_standard_question => true
  }
})

#Entering User Types

UserType.create!(name: "Superuser")
UserType.create!(name: "Organisation")
UserType.create!(name: "Entity")
