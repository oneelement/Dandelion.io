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

  #Spy on jQuery ajax
  @ajaxSpy = sinon.spy(jQuery, 'ajax')

afterEach ->
  jQuery.ajax.restore()

describe 'ProductEditorApp model', ->

  describe 'when created', ->

    it 'should get default suggestions', ->

      app = new ProductEditor.Models.ProductEditorApp()

      for url in ['/sections']
        calledUrl = false

        for callArgs in @ajaxSpy.args
          if callArgs[0].url == url and callArgs[0].data.suggestions
            calledUrl = true

        expect(calledUrl).toBeTruthy()


  describe 'when no product section is selected', ->

    app = new ProductEditor.Models.ProductEditorApp()

    it 'should add sections to the root product version', ->

      newSec = new ProductEditor.Models.Section()
      app.addSection(newSec)

      expect(app.version.get("product_sections").length).toEqual(1)


  describe 'when a product section is selected', ->

    app = new ProductEditor.Models.ProductEditorApp()
    sec = new ProductEditor.Models.Section(
      id: 'abc123'
    )
    app.addSection(sec)

    productSection = app.version.get("product_sections").models[0]

    app.selectProductSection(productSection)

    it 'should add sections to the selected product section', ->

      newSec = new ProductEditor.Models.Section()
      app.addSection(newSec)

      expect(productSection.get("product_sections").length).toEqual(1)

