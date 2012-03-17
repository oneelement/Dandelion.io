#= require_tree ../fixtures

describe 'ProductSection model', ->

  beforeEach ->
    @server = sinon.fakeServer.create()
    @server.respondWith("/sections/1",
      @validResponse(@fixtures.Sections.sectionWithMetadata))


  describe 'when being created from a section, and loading defaults', ->

    beforeEach ->
      @section = new ProductEditor.Models.Section(id: 1)
      @section.fetch()
      @server.respond()

      @productSection = new ProductEditor.Models.ProductSection(section: @section)

    it 'should store a reference to the section', ->

      expect(@productSection.get("section")).toEqual(@section)

    it 'loadDefaults should suggested attributes from metadata', ->

      @productSection.loadDefaults()

      expect(@productSection.get("repeats")).toEqual(@section.get("builder_metadata").repeats)

      expect(@productSection.get("repeat_max_instances")).toEqual(@section.get("builder_metadata").repeat_max_instances)
