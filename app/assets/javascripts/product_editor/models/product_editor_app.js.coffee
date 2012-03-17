class ProductEditor.Models.ProductEditorApp extends Backbone.Model
  initialize: ->
    @version = new ProductEditor.Models.ProductVersion(
      id: $('#version-id').text()
      product_id: $('#product-id').text())
    
    @suggestedSections = new ProductEditor.Collections.Sections()
    @suggestedQuestions = new ProductEditor.Collections.Questions()

    @bind("change:selectedProductSection", (model, newSelection) ->
        #Trigger change on old and new selection so the selection highlighting updates
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

    @bind("change:selectedProductQuestion", (model, newSelection) ->
        #Trigger change on old and new selection so the selection highlighting updates
        prevSelection = @previous("selectedProductQuestion")
        if prevSelection?
          prevSelection.trigger("change")

        if newSelection?
          newSelection.trigger("change")
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

    @unset("selectedProductQuestion")

  selectProductQuestion: (productQuestion) ->
    if @get("selectedProductQuestion") == productQuestion
      @unset("selectedProductQuestion")
    else
      @set("selectedProductQuestion", productQuestion)

  addSection: (section) ->
    selected = @get("selectedProductSection")
    if selected?
      selected.addSection(section)
    else
      @version.addSection(section)

  removeSection: (section) ->
    if section?
      if section == @get("selectedProductSection")
        section.set("_destroy", true)
        @unset("selectedProductSection")

  addQuestion: (question) ->
    selected_section = @get("selectedProductSection")
    if selected_section?
      selected_section.addQuestion(question)

  removeQuestion: (question) ->
    if question?
      if question == @get("selectedProductQuestion")
        question.set("_destroy", true)
        @unset("selectedProductQuestion")

  save: ->
    @version.save()
