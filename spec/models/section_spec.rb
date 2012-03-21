describe Section do
  it "has a name" do
    s = Section.new()
    s.should_not be_valid

    s.name = "Test section"
    s.should be_valid
  end
end
