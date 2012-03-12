beforeEach ->
  if not @fixtures?
    @fixtures = {}

  @fixtures.Questions = {
    suggestions: {
      "status": "OK",
      "version": "1.0",
      "response": [
        {
          "_id": "1",
          "name": "Example question"
        }
      ]
    }
  }
