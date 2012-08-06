class RippleApp.Views.Notification extends Backbone.View
  template: JST['contact_manager/notification']
  #poss now obsolete
  contactRipple: JST['contact_manager/notification_ripple']
  rippleAccept: JST['contact_manager/notification_ripple_accept']
  tagName: 'li'
  className: 'notification'
  
  events:
    'click': 'setAsRead'
    'click .share-contact-reject': 'setReject'
    'click .share-contact-accept': 'setAccept'
    'click .share-contact-user-accept': 'setContactAccept'
    
  initialize: ->
    @model.on('change', @render, this)
    @unreadCount = @options.unread
    #console.log(@unreadCount)

  render: ->    
    if @model.get('_type') == 'NotificationRipple'
      $(@el).html(@template(notification: @model.toJSON()))
    else if @model.get('_type') == 'NotificationContactRipple'
      $(@el).html(@contactRipple(notification: @model.toJSON())) #poss change back to @template
    else if @model.get('_type') == 'NotificationRippleAccept'
      $(@el).html(@rippleAccept(notification: @model.toJSON()))
      
    if @model.get('is_read') == false
      $(this.el).addClass('un-read')
    else 
      $(this.el).removeClass('un-read')
    
    return this
    
  setAsRead: ->
    if @model.get('is_read') == false
      console.log('Set as Read')      
      #@unreadCount = @unreadCount - 1
      #console.log(@unreadCount)
      #$('.unread-count').html(@unreadCount)      
      if @model.get('_type') == 'NotificationRippleAccept'
        @model.save(is_actioned: true, is_read: true)
        @col = RippleApp.contactsRouter.notifications
        @col.remove(@model)
        @getContact()
      else
        @model.save(is_read: true)
      @collection.remove(@model)
      
  getContact: ->
    @contacts = RippleApp.contactsRouter.contacts
    @contacts.fetch()
    
  setNotification: ->
    @model.save(is_actioned: true, is_read: true)
    @col = RippleApp.contactsRouter.notifications
    @col.remove(@model)  
    
  addAcceptNotification: ->
    @notification = new RippleApp.Models.Notification()
    user_id = @model.get('sent_id') 
    sent_id = @model.get('user_id') 
    @notification.set(
      _type: 'NotificationRippleAccept'
      user_id: user_id
    )
    console.log(@notification)
    @notification.save()
    
  setReject: ->
    #console.log('Reject')
    #@model.save(is_actioned: true, is_read: true)
    #$(this.el).empty().css('display','none')
    #@col = RippleApp.contactsRouter.notifications
    #@col.remove(@model)
    @setNotification()
   
    
  setAccept: ->
    console.log('Accept')
    #@model.save(is_actioned: true, is_read: true)
    #@col = RippleApp.contactsRouter.notifications
    #@col.remove(@model)
    @setNotification()
    #@notification = new RippleApp.Models.Notification()
    #user_id = @model.get('sent_id') 
    #sent_id = @model.get('user_id') 
    #@notification.set(
    #  _type: 'NotificationRippleAccept'
    #  user_id: user_id
    #)
    #console.log(@notification)
    #@notification.save()
    @addAcceptNotification()
    @completeRipple()
    
  #poss now obsolete
  setContactAccept: ->
    console.log('Contact Accept')
    @setNotification()
    @addAcceptNotification()
    @completeContactRipple()
    
  completeRipple: ->
    console.log('Complete Ripple')
    id = @model.get('_id')
    $.get '/notifications/complete_ripple/?id=' + id
    
  #poss now obsolete  
  completeContactRipple: ->
    id = @model.get('_id')
    $.get '/notifications/complete_ripple/?id=' + id
    
    
    


