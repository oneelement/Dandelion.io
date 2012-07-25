class RippleApp.Views.UserCard extends Backbone.View
  template: JST['contact_manager/user_card']
  id: 'contact-card'
    
  events:
    'click #contact-user-ripple': 'sendRequest'

  initialize: ->
    console.log(@model)
    @current_user = @options.current_user
    @target_user = @options.target_user
    console.log(@current_user)
    console.log(@target_user)
    
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    @outputMap()
    
    return this
    
  outputMap: ->
    c = new RippleApp.Collections.Addresses(@model.get("addresses"))
    if c.length == 0
      coll = new RippleApp.Collections.Addresses()
      collection = coll
    else
      collection = @model.get("addresses")
    
    map = new RippleApp.Views.ContactCardMap(
      collection: collection
    )
    $('#contact-card-map', @el).append(map.render().el)
    
  sendRequest: ->
    console.log(@model)
    @notification = new RippleApp.Models.Notification()
    console.log(@current_user.get('_id'))
    console.log(@target_user.get('_id'))
    user_id = @target_user.get('_id') 
    @notification.set(
      _type: 'NotificationRipple'
      user_id: user_id
    )
    console.log(@notification)
    @notification.save()