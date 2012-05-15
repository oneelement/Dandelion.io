class RippleApp.Models.Group extends Backbone.RelationalModel
  relations: [
    {
      type: 'Backbone.HasMany'
      key: 'addresses'
      relatedModel: 'RippleApp.Models.GroupAddressDetail'
      includeInJSON: true
      createModels: true
    },
    {
      type: 'Backbone.HasMany'
      key: 'notes'
      relatedModel: 'RippleApp.Models.GroupNoteDetail'
      includeInJSON: true
      createModels: true
    },
  ]
  idAttribute: '_id'
  urlRoot: -> '/groups/'