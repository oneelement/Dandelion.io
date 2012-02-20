class Onelement.Models.ProductSection extends Backbone.RelationalModel
  relations: [
    {
      type: 'Backbone.HasOne'
      key: 'section'
      relatedModel: 'Onelement.Models.Section'
      includeInJSON: true
      createModels: true
    }, {
      type: 'HasMany'
      key: 'product_sections'
      relatedModel: 'Onelement.Models.ProductSection'
      collectionType: 'Onelement.Collections.ProductSections'
      includeInJSON: true
      createModels: true
    }
  ]

  clearSelected: ->
    @set("selected", false)
    children = @get("product_sections").models
    _.each(
      children
      (child) ->
        child.clearSelected())
