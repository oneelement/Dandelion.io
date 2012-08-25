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
      key: 'urls'
      relatedModel: 'RippleApp.Models.ContactUrlDetail'
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
    {
      type: 'Backbone.HasMany'
      key: 'emails'
      relatedModel: 'RippleApp.Models.ContactEmailDetail'
      includeInJSON: true
      createModels: true
    },
  ]
  idAttribute: '_id'
  urlRoot: -> '/groups/'
  
  getBadge: =>
    contactBadge = new RippleApp.Models.ContactBadge()
    contactBadge.set('id', @id)
    contactBadge.set('name', @.get('name'))
    contactBadge.set('avatar', @.get('avatar'))
    contactBadge.set('type', 'group')
    contactBadge
  
  getModelName: ->
    return "group"