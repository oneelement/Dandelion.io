beforeEach ->
  if not @fixtures?
    @fixtures = {}

  @fixtures.Questions = {
    suggestions: [
      {
        "_id": "1",
        "name": "Example question"
      }
    ]
  }
