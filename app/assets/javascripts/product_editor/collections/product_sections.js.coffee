class ProductEditor.Collections.ProductSections extends Backbone.Collection
  model: ProductEditor.Models.ProductSection

  visibleModels: ->
    _.filter(@models, (model) -> not model.get("_destroy"))

  hasVisible: ->
    @visibleModels().length > 0
