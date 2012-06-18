class RippleApp.Models.Hashtag extends Backbone.RelationalModel
  urlRoot: '/hashtags'
  idAttribute: '_id'
  
  getTypes: ->
    types = []
    return types  
  
  getViewIcon: ->
      return 'hashtag'
  
  getViewValue: ->
    return @get("text")
    
  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "hashtag"
    
  removeContact: (contact_id) ->
    contact_ids = this.get('contact_ids')
    position = _.indexOf(contact_ids, contact_id)
    contact_ids.splice(position, 1)
    this.set('contact_ids', [])
    this.set('contact_ids', contact_ids)
    this.save()