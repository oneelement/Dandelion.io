class ProductEditor.Collections.Sections extends Backbone.Collection
  url: '/sections'
  model: ProductEditor.Models.Section
  fetchSuggestions: (id) ->
    @fetch(
      data:
        suggestions: true
        id: id)

  fetchCustom: (id) ->
    @fetch(
      data:
        custom: true
        id: id)

  notAlreadyAddedToSelected: ->
    #Return a list of sections which haven't already been added to the selected section.
    #If no section is selected, do the same but for top level sections
    child_section_ids = []

    selectedSection = ProductEditor.app.get("selectedProductSection")

    if selectedSection?
      child_section_ids = _.map(selectedSection.get("product_sections").models, (product_section) ->
        if not product_section.get("_destroy")
          return product_section.get("section").id
      )
    else
      child_section_ids = _.map(ProductEditor.app.version.get("product_sections").models, (product_section) ->
        if not product_section.get("_destroy")
          return product_section.get("section").id
      )

    return _.filter(@models, (model) -> not _.include(child_section_ids, model.id))
