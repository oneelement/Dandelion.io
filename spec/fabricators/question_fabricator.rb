Fabricator(:question) do
  name "Test question"
  builder_details_container { Fabricate.build(:builder_details_container) }
end

Fabricator(:builder_details_container, class_name: 'BuilderQuestionDetailsContainer') do
  section
  is_standard_question true
end
