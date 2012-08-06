class RippleApp.Views.NotificationCount extends Backbone.View
  template: JST['contact_manager/notification_count']
  tagName: 'span'
  className: 'unread-count'

    
  initialize: ->
    console.log('Notification Count View')
    @collection.on('add remove reset destroy', @render, this)
    #@unread_count = @collection.length
    console.log(@collection)

  render: ->    
    unread_count = @collection.length
    $(@el).html(@template(unreadCount: unread_count))
    if unread_count == 0
      $(this.el).removeClass('new-mail')
    else
      $(this.el).addClass('new-mail')

    
    return this
    



