class RippleApp.Models.Group extends Backbone.RelationalModel
  relations: [
    {
      type: 'Backbone.HasMany'
      key: 'socials'
      relatedModel: 'RippleApp.Models.ContactSocialDetail'
      includeInJSON: true
      createModels: true
    },
    {
      type: 'Backbone.HasMany'
      key: 'phones'
      relatedModel: 'RippleApp.Models.ContactPhoneDetail'
      includeInJSON: true
      createModels: true
    },
    {
      type: 'Backbone.HasMany'
      key: 'addresses'
      relatedModel: 'RippleApp.Models.ContactAddressDetail'
      includeInJSON: true
      createModels: true
    },
    {
      type: 'Backbone.HasMany'
      key: 'notes'
      relatedModel: 'RippleApp.Models.ContactNoteDetail'
      includeInJSON: true
      createModels: true
    },
  ]
  idAttribute: '_id'
  urlRoot: -> '/groups/'