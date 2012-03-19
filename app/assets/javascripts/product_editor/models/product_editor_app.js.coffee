class ProductEditor.Models.ProductEditorApp extends Backbone.Model
  initialize: ->
    @version = new ProductEditor.Models.ProductVersion(
      id: $('#version-id').text()
      product_id: $('#product-id').text())
    
    @suggestedSections = new ProductEditor.Collections.Sections()
    @suggestedQuestions = new ProductEditor.Collections.Questions()

    @customSections = new ProductEditor.Collections.Sections()
    @customQuestions = new ProductEditor.Collections.Questions()

    @bind("change:selectedProductSection", (model, newSelection) ->
        #Trigger change on old and new selection so the selection highlighting updates
        prevSelection = @previous("selectedProductSection")
        if prevSelection?
          prevSelection.trigger("change")

        if newSelection?
          @suggestedSections.fetchSuggestions(newSelection.get("section").id)
          @suggestedQuestions.fetchSuggestions(newSelection.get("section").id)
          @customSections.fetchCustom(newSelection.get("section").id)
          @customQuestions.fetchCustom(newSelection.get("section").id)
          newSelection.trigger("change")
        else
          @suggestedSections.fetchSuggestions()
          @suggestedQuestions.fetchSuggestions()
          @customSections.fetchCustom()
          @customQuestions.fetchCustom()
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
    @version.fetch(
      success: ->
        $('#sections').fadeIn(500)
    )
    @suggestedSections.fetchSuggestions()
    @suggestedQuestions.fetchSuggestions()
    @customSections.fetchCustom()
    @customQuestions.fetchCustom()

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
    product_section = new ProductEditor.Models.ProductSection(section: section)
    product_section.loadDefaults()

    selected = @get("selectedProductSection")
    if selected?
      selected.addSection(product_section)
    else
      @version.addSection(product_section)
      
    #Redraw suggestions
    @suggestedSections.trigger("reset")

    return product_section

  removeSelectedSection: ->
    section = @get("selectedProductSection")
    if section?
      section.set("_destroy", true)
      @unset("selectedProductSection")
      
    #Redraw suggestions
    @suggestedSections.trigger("reset")

  addQuestion: (question) ->
    selected_section = @get("selectedProductSection")
    if selected_section?
      selected_section.addQuestion(question)
      
    #Redraw suggestions
    @suggestedQuestions.trigger("reset")

  removeSelectedQuestion: ->
    question = @get("selectedProductQuestion")
    if question?
      question.set("_destroy", true)
      @unset("selectedProductQuestion")
      
    #Redraw suggestions
    @suggestedQuestions.trigger("reset")

  save: ->
    @version.save()
