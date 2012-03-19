Fabricator(:section) do
  name 'Standard top level section'
  builder_details_container { Fabricate.build(:section_details) }
end

Fabricator(:section_details, :class_name => 'BuilderSectionDetailsContainer') do
  is_top_level true
  is_standard_section true
  repeats true
  repeats_max_instances 5
end
