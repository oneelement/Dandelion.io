require "spec_helper"

describe PossibleAnswer do
  it "has a value" do
    a = PossibleAnswer.new()
    a.should_not be_valid

    a.value = 'test possible answer'
    a.should be_valid
  end

  it "can belong to a group" do
    a = PossibleAnswer.new({:value => "test", :possible_answer_group => Fabricate(:possible_answer_group)})
    a.possible_answer_group.name.should == 'Test group'
  end
end
