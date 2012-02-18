require "spec_helper"

describe Section do
  it "has a name" do
    s = Section.new()
    s.should_not be_valid

    s.name = "Test section"
    s.should be_valid
  end

  context "when builder metadata is filled out" do
    let(:section) do
      Fabricate.build(:section_with_metadata)
    end

    it "should suggest questions" do
      section.suggested_questions.count.should_not == 0
    end

    it "should suggest child sections" do
      section.suggested_child_sections.count.should_not == 0
    end
  end
end
