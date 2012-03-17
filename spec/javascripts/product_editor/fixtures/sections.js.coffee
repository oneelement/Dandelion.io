beforeEach ->
  if not @fixtures?
    @fixtures = {}

  @fixtures.Sections = {
    suggestions: [
      {
        "id": "1",
        "name": "Example section"
      }
    ]
    sectionWithMetadata: {
      "id": "1",
      "name": "Example section"
      "builder_metadata": {
        "is_standard_section": true,
        "is_top_level": false,
        "repeats": true,
        "repeat_max_instances": 5
      }
    }
  }
