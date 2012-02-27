class Onelement.Models.ProductQuestion extends Backbone.RelationalModel
  relations: [
    type: 'Backbone.HasOne'
    key: 'question'
    relatedModel: 'Onelement.Models.Question'
    includeInJSON: true
    createModels: true
  ]
