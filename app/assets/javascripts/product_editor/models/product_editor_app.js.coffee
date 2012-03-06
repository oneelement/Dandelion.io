class ProductEditor.Models.ProductEditorApp extends Backbone.Model
  initialize: ->
    @version = new ProductEditor.Models.ProductVersion
      _id: $('#version-id').text()
      product_id: $('#product-id').text()
    
    @suggestedSections = new ProductEditor.Collections.Sections()
    @suggestedQuestions = new ProductEditor.Collections.Questions()

    @bind("change:selectedProductSection", (model, newSelection) ->
        prevSelection = @previous("selectedProductSection")
        if prevSelection?
          prevSelection.trigger("change")

        if newSelection?
          @suggestedSections.fetchSuggestions(newSelection.get("section").id)
          @suggestedQuestions.fetchSuggestions(newSelection.get("section").id)
          newSelection.trigger("change")
        else
          @suggestedSections.fetchSuggestions()
          @suggestedQuestions.fetchSuggestions()
      @)

  initialFetch: ->
    @version.fetch()
    @suggestedSections.fetchSuggestions()
    @suggestedQuestions.fetchSuggestions()

  selectProductSection: (productSection) ->
    if @get("selectedProductSection") == productSection
      @unset("selectedProductSection")
    else
      @set("selectedProductSection", productSection)

  addSection: (section) ->
    selected = @get("selectedProductSection")
    if selected?
      selected.addSection(section)
    else
      @version.addSection(section)

  addQuestion: (question) ->
    selected_section = @get("selectedProductSection")
    if selected_section?
      selected_section.addQuestion(question)

  save: ->
    @version.save()
