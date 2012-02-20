Fabricator(:section) do
  name 'Test section'
end

Fabricator(:section_with_metadata, class_name: 'Section') do
  name 'Test section'
  after_build do |s|
    s.builder_metadata = Fabricate.build(:builder_section_metadata)
  end
end

Fabricator(:builder_section_metadata, class_name: 'BuilderSectionMetadata') do
  suggested_questions {[Fabricate(:question)]}
  suggested_child_sections {[Fabricate(:section)]}
end
