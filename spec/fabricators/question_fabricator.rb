Fabricator(:question) do
  name "Test question"
  section {Fabricate(:section)}
end

Fabricator(:question_with_metadata, class_name: 'Question') do
  name "Test question"
  section {Fabricate(:section)}
  after_build do |q|
    q.builder_metadata = Fabricate.build(:builder_question_metadata)
  end
end

Fabricator(:builder_question_metadata, class_name: 'BuilderQuestionMetadata') do
  after_build do |meta|
    meta.suggested_possible_answer_group = Fabricate(:possible_answer_group)
  end
end
