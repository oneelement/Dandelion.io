class RippleApp.Views.Mailbox extends Backbone.View
  template: JST['contact_manager/mailbox']
  id: 'mail'
  
  events:
    'click #mail-icon': 'openInbox'
  
  initialize: ->
    #@unread_count = 0
    console.log('Mailbox View')
    @collection.on('reset add remove destroy', @render, this)
    #@unread_count.on('change', @render, this)
    

  render: ->
    @unread = @collection.unread()
    @unactioned = @collection.un_actioned()
    #console.log(@unread)
    #console.log(@unread.models)
    @unread_count = @unread.length
    
    @unreadCollection = new RippleApp.Collections.Notifications()
    @unreadCollection.add(@unread)
    
    #console.log(@unread_count)
    $(@el).html(@template(unreadCount: @unread_count))
    #console.log(@collection)
    if @unread_count == 0
      $('.unread-count').removeClass('new-mail')
      $('#mail-icon').addClass('dicon-drawer-2')
      $('#mail-icon').removeClass('dicon-drawer')
    else
      $('.unread-count').addClass('new-mail')
      $('#mail-icon').addClass('dicon-drawer')
      $('#mail-icon').removeClass('dicon-drawer-2')
      
    view = new RippleApp.Views.NotificationCount(collection: @unreadCollection)
    $(this.el).append(view.render().el)   
    
    @populateNotifications(@unread_count)
    
    return @
    
  openInbox: ->
    console.log('Open Inbox')
    $('#mail').toggleClass('view')
    $('#account-info').removeClass('view')
    
  populateNotifications: (unread_count) =>
    console.log('Populate Notifications')    
    if @unactioned.length > 0
      @will_sync = false
      _.each(@unactioned, (model) =>
        console.log(model)
        if model.get('_type') == 'NotificationRippleAccept'
          console.log('begin here')
          if model.get('is_synced') == false
            model.set('is_synced', true)
            model.save()
            @will_sync = true
        view = new RippleApp.Views.Notification(
          model: model
          unread: @unread_count
          collection: @unreadCollection
        )
        this.$('#notifications').append(view.render().el)
      )
      if @will_sync == true
        console.log('syncing')
        @current_user = RippleApp.contactsRouter.currentUser
        @current_user.fetch()
        @user_contacts = RippleApp.contactsRouter.userContacts
        @user_contacts.fetch()
        @contacts = RippleApp.contactsRouter.contacts
        @contacts.fetch()
      
    else
      view = '<li class="notification empty">No new notifications</li>'
      this.$('#notifications').append(view)
   


