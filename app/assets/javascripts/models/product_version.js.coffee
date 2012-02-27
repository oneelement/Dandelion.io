class Onelement.Models.ProductVersion extends Backbone.RelationalModel
  urlRoot: -> '/products/' + @get('productId') + '/versions'
  relations: [
    {
      type: 'HasMany'
      key: 'product_sections'
      relatedModel: 'Onelement.Models.ProductSection'
      collectionType: 'Onelement.Collections.ProductSections'
      includeInJSON: true
      createModels: true
    },{
      type: 'HasOne'
      key: 'selectedSection'
      relatedModel: 'Onelement.Models.ProductSection'
      includeInJSON: true
      createModels: true
    }
  ]

  initialize: ->
    @bind("add:product_sections",
      -> @trigger("change"),
      @)
    @bind("remove:product_sections",
      -> @trigger("change"),
      @)

    @bind("change:selectedSection", @selectedSectionChanged)
    @bind("change",
      ->
        console.log('changed')
        console.log(@)
      @)

  addSection: (section) ->
    s = new Onelement.Models.ProductSection(section: section)
    #Add event triggers, so if sections are added/removed to the new
    #section, then the product version's change event is triggered.
    #This is needed for redrawing.
    s.bind("add:product_sections",
      -> @trigger("change"),
      @)
    s.bind("remove:product_sections",
      -> @trigger("change"),
      @)
    s.bind("add:product_questions",
      -> @trigger("change"),
      @)
    s.bind("remove:product_questions",
      -> @trigger("change"),
      @)


    currentSection = @get("selectedSection")
    if currentSection?
        currentSection.get("product_sections").add(s)
    else
        @get("product_sections").add(s)

  addQuestion: (question) ->
    q = new Onelement.Models.ProductQuestion(question: question)

    currentSection = @get("selectedSection")
    if currentSection?
      currentSection.get("product_questions").add(q)

  selectSection: (section) ->
    #Deselect current if 'selecting' the currently selected section
    if @get("selectedSection") == section
      @set("selectedSection", null)
    else
      @set("selectedSection", section)

  selectedSectionChanged: (model, selectedSection) ->
    #Clear selection on all sections
    sections = @get("product_sections").models
    _.each(
      sections
      (section) ->
        section.clearSelected())

    if selectedSection?
      #Set new selection
      @get('selectedSection').set('selected', true)
      id = @get('selectedSection').get("section").get("_id")
      ProductVersions.navigate('sections/' + id, {trigger: true})

    else
      #Selection cleared, navigate to root
      ProductVersions.navigate('', {trigger: true})
