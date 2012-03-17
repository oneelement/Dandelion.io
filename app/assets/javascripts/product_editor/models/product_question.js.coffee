class ProductEditor.Models.ProductQuestion extends Backbone.RelationalModel
  relations: [
    type: 'Backbone.HasOne'
    key: 'question'
    relatedModel: 'ProductEditor.Models.Question'
    includeInJSON: true
    createModels: true
  ]
