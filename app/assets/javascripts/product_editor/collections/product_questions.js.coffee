class ProductEditor.Collections.ProductQuestions extends Backbone.Collection
  model: ProductEditor.Models.ProductQuestion

  visibleModels: ->
    _.filter(@models, (model) -> not model._destroy?)

  hasVisible: ->
    @visibleModels().length > 0
