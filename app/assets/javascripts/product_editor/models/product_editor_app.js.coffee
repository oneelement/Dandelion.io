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
          newSelection.trigger("change")

        @fetchAll()
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
    @fetchAll()

  fetchAll: ->
    selected = @get("selectedProductSection")
    if selected?
      s_id = selected.get("section").id
      @suggestedSections.fetchSuggestions(s_id)
      @suggestedQuestions.fetchSuggestions(s_id)
      @customSections.fetchCustom(s_id)
      @customQuestions.fetchCustom(s_id)
    else
      @suggestedSections.fetchSuggestions()
      @customSections.fetchCustom()

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
    @customSections.trigger("reset")

    return product_section

  removeSelectedSection: ->
    section = @get("selectedProductSection")
    if section?
      section.set("_destroy", true)
      @unset("selectedProductSection")
      
    #Redraw suggestions
    @suggestedSections.trigger("reset")
    @customSections.trigger("reset")

  addQuestion: (question) ->
    selected_section = @get("selectedProductSection")
    if selected_section?
      selected_section.addQuestion(question)
      
    #Redraw suggestions
    @suggestedQuestions.trigger("reset")
    @customQuestions.trigger("reset")

  removeSelectedQuestion: ->
    question = @get("selectedProductQuestion")
    if question?
      question.set("_destroy", true)
      @unset("selectedProductQuestion")
      
    #Redraw suggestions
    @suggestedQuestions.trigger("reset")
    @customQuestions.trigger("reset")

  addCustomSection: (details) ->
    selectedSection = @get("selectedProductSection")

    newSection = new ProductEditor.Models.Section(details)

    if selectedSection?
      builder_details_container = {
        section_id: selectedSection.get("section").id
      }
    else
      builder_details_container = {
        is_top_level: true
      }

    newSection.set("builder_details_container", builder_details_container)
    newSection.save([],
      success: =>
        @fetchAll()
    )

  addCustomQuestion: (details) ->
    selectedSection = @get("selectedProductSection")

    if selectedSection?
      builder_details_container = {
        section_id: selectedSection.get("section").id
      }

      question_type = {
        _type: details.type
      }

      newQuestion = new ProductEditor.Models.Question(
        name: details.name
      )
      newQuestion.set("builder_details_container", builder_details_container)
      newQuestion.set("question_type", question_type)

      newQuestion.save([],
        success: =>
          @fetchAll()
      )

  save: ->
    @version.save()
