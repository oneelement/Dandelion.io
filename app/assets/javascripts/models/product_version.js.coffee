class Onelement.Models.ProductVersion extends Backbone.RelationalModel
  urlRoot: -> '/products/' + @get('productId') + '/versions'
  relations: [
    type: 'HasMany'
    key: 'product_sections'
    relatedModel: 'Onelement.Models.ProductSection'
    collectionType: 'Onelement.Collections.ProductSections'
    includeInJSON: true
    createModels: true
  ]

  initialize: ->
    @bind(
      "add:product_sections",
      -> @trigger("change"),
      @)

    @bind(
      "remove:product_sections",
      -> @trigger("change"),
      @)

    @bind("change:selectedSection", @selectedSectionChanged)

  addSection: (section) ->
    s = new Onelement.Models.ProductSection(section: section)
    s.bind(
        "add:product_sections",
        -> @trigger("change"),
        @)
    s.bind(
        "remove:product_sections",
        -> @trigger("change"),
        @)


    currentSelection = @get("selectedSection")
    if currentSelection?
        currentSelection.get("product_sections").add(s)
    else
        @get("product_sections").add(s)

    console.log(@toJSON())

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
