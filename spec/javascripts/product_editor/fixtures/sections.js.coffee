beforeEach ->
  if not @fixtures?
    @fixtures = {}

  @fixtures.Sections = {
    suggestions: {
      "status": "OK",
      "version": "1.0",
      "response": [
        {
          "_id": "1",
          "name": "Example section"
        }
      ]
    }
  }
