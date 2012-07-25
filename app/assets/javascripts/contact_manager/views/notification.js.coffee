class RippleApp.Views.Notification extends Backbone.View
  template: JST['contact_manager/notification']
  tagName: 'li'
  className: 'notification'
  
  events:
    'click': 'setAsRead'
    'click .share-contact-reject': 'setReject'
    
  initialize: ->
    @model.on('change', @render, this)
    @unreadCount = @options.unread
    #console.log(@unreadCount)

  render: ->    
    $(@el).html(@template(notification: @model.toJSON()))
    if @model.get('is_read') == false
      $(this.el).addClass('un-read')
    else 
      $(this.el).removeClass('un-read')
    
    return this
    
  setAsRead: ->
    if @model.get('is_read') == false
      console.log('Set as Read')
      @model.save(is_read: true)
      #@unreadCount = @unreadCount - 1
      #console.log(@unreadCount)
      #$('.unread-count').html(@unreadCount)
      @collection.remove(@model)
    
  setReject: ->
    console.log('Reject')
    @model.save(is_actioned: true, is_read: true)
    #$(this.el).empty().css('display','none')
    @col = RippleApp.contactsRouter.notifications
    @col.remove(@model)
    
    
    


