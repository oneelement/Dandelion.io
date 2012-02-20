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

  selectedSectionChanged: ->
    #Clear selection on all sections
    sections = @get("product_sections").models
    _.each(
      sections
      (section) ->
        section.clearSelected())

    #Set new selection
    @get('selectedSection').set('selected', true)

