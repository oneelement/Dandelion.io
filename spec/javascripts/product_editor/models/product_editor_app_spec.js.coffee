#= require sinon
#= require_tree ../../helpers
#= require_tree ../fixtures

sectionSuggestionArgs =
  "suggestions": true

questionSuggestionArgs =
  "url": '/sections'
  "data":
    "suggestions": true

beforeEach ->
  #Mock out the server
  @server = sinon.fakeServer.create()
  @server.respondWith("/sections",
    @validResponse(@fixtures.Sections.suggestions))

  @server.respondWith("/questions",
    @validResponse(@fixtures.Questions.suggestions))


  #Create a new app each time
  @app = new ProductEditor.Models.ProductEditorApp()

  #Spy on version, and suggested sections and questions
  @sugSectionsSpy = sinon.spy(@app.suggestedSections, "fetchSuggestions")
  @sugQuestionsSpy = sinon.spy(@app.suggestedQuestions, "fetchSuggestions")

describe 'ProductEditorApp model', ->

  describe 'when populated', ->

    beforeEach ->
      @versionSpy = sinon.spy(@app.version, "fetch")
      @app.populate()

    it 'should get the product version', ->

      expect(@versionSpy.called).toBeTruthy()

    it 'should get default suggestions', ->

      expect(@sugSectionsSpy.calledWithExactly()).toBeTruthy()
      expect(@sugQuestionsSpy.calledWithExactly()).toBeTruthy()

  describe 'when no product section is selected', ->

    beforeEach ->
      @newSec = new ProductEditor.Models.Section(
        _id: 'a1b1c1d1'
      )

      @app.addSection(@newSec)

    it 'should add sections to the root product version', ->

      expect(@app.version.get("product_sections").length).toEqual(1)

    it 'should load suggestions when one is selected', ->

      newProductSection = @app.version.get("product_sections").models[0]
      @app.selectProductSection(newProductSection)

      expect(@sugSectionsSpy.calledWithExactly(@newSec.id)).toBeTruthy()
      expect(@sugQuestionsSpy.calledWithExactly(@newSec.id)).toBeTruthy()

  describe 'when a product section is selected', ->

    beforeEach ->
      @newSec = new ProductEditor.Models.Section(
        _id: 'a2b2c2d2'
      )

      @app.addSection(@newSec)
      @productSection = @app.version.get("product_sections").models[0]

      @app.selectProductSection(@productSection)

    it 'should add sections to the selected product section', ->

      anotherNewSec = new ProductEditor.Models.Section()
      @app.addSection(anotherNewSec)

      expect(@productSection.get("product_sections").length).toEqual(1)

