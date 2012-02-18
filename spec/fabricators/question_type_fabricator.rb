Fabricator(:question_type) do
  name 'freetext'
end

Fabricator(:question_type_dropdown, class_name: 'QuestionType') do
  name 'dropdown'
end
