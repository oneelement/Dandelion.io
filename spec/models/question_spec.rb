require "spec_helper"

describe Question do
  it "must have a section" do
    q = Question.new({:name => 'test question'})
    q.should_not be_valid
  end

  it "works with a section" do
    q = Question.new({:name => 'test question', :section => Fabricate(:section)})
    q.should be_valid
  end

  context "when the question has metadata" do
    let(:question) do
      Fabricate.build(:question_with_metadata)
    end

  end
end
