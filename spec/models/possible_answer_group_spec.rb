require "spec_helper"

describe PossibleAnswerGroup do

  it "has a name" do
    grp = PossibleAnswerGroup.new()
    grp.should_not be_valid

    grp.name = "test group"
    grp.should be_valid
  end

  it "can take nested answers when it's created" do
    grp = PossibleAnswerGroup.new({
      :name => "test group", 
      :possible_answers_attributes => [
        {:value => "Example answer 1"},
        {:value => "Example answer 2"}
      ]
    })

    grp.should be_valid
    grp.save
    
    grp.possible_answers.first.value.should == "Example answer 1"
  end

end
