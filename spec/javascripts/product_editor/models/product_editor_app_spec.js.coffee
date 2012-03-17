#= require_tree ../fixtures

sectionSuggestionArgs =
  "suggestions": true

questionSuggestionArgs =
  "url": '/sections'
  "data":
    "suggestions": true

describe 'ProductEditorApp model', ->

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


  describe 'when initialFetch is called', ->

    beforeEach ->
      @versionSpy = sinon.spy(@app.version, "fetch")
      @app.initialFetch()

    it 'should get the product version', ->

      expect(@versionSpy.called).toBeTruthy()

    it 'should get default suggestions', ->

      expect(@sugSectionsSpy.calledWithExactly()).toBeTruthy()
      expect(@sugQuestionsSpy.calledWithExactly()).toBeTruthy()

  describe 'when no product section is selected', ->

    beforeEach ->
      @newSec = new ProductEditor.Models.Section(
        id: 'a1b1c1d1'
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
      @newSec = new ProductEditor.Models.ProductSection(
        id: 'a2b2c2d2'
      )

      @app.addSection(@newSec)
      @productSection = @app.version.get("product_sections").models[0]

      @app.selectProductSection(@productSection)

      @anotherNewSec = new ProductEditor.Models.ProductSection()

    it 'should populate the selectedProductSection attribute', ->
      expect(@app.get("selectedProductSection")).toEqual(@productSection)

    it 'should add sections to the selected product section', ->

      @app.addSection(@anotherNewSec)
      expect(@productSection.get("product_sections").length).toEqual(1)

    it 'removeSelectedSection should set destroy on the selected section', ->
      selected = @app.get("selectedProductSection")
      @app.removeSelectedSection()

      expect(selected.get("_destroy")).toBeTruthy()

    it 'should add questions to the selected product section', ->
      selected = @app.get("selectedProductSection")
      newQuestion = new ProductEditor.Models.ProductQuestion(
        id: 'a5b5c5d5')

      @app.addQuestion(newQuestion)
      expect(selected.get("product_questions").length).toEqual(1)

  describe 'when a product question is selected', ->

    beforeEach ->
      @newSec = new ProductEditor.Models.ProductSection(
        id: 'a3b3c3d3')
      @newQuestion = new ProductEditor.Models.ProductQuestion(
        id: 'a4b4c4d4')

      @newSec.addQuestion(@newQuestion)
      @app.addSection(@newSec)

      @app.selectProductQuestion(@newQuestion)

    it 'should populate the selectedProductQuestion attribute', ->
      expect(@app.get("selectedProductQuestion")).toEqual(@newQuestion)

    it 'removeSelectedQuestion should set destroy on the selected question', ->
      selected = @app.get("selectedProductQuestion")
      @app.removeSelectedQuestion()
      expect(selected.get("_destroy")).toBeTruthy()
