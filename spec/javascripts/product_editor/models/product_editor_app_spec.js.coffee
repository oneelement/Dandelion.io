describe 'ProductEditorApp model', ->

  describe 'when created', ->

    it 'should get default suggestions', ->
      app = new ProductEditor.Models.ProductEditorApp()

      expect(app.suggestedSections.length).toBeGreaterThan(0)
      expect(app.suggestedQuestions.length).toBeGreaterThan(0)

