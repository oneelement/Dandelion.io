class Onelement.Models.ProductQuestion extends Backbone.RelationalModel
  idAttribute: '_id'
  relations: [
    type: 'Backbone.HasOne'
    key: 'question'
    relatedModel: 'Onelement.Models.Question'
    includeInJSON: true
    createModels: true
  ]
