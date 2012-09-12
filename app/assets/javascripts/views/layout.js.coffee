class RippleApp.Views.Layout extends Backbone.View
  id: 'view-layout'
  template: JST['contact_manager/layout']
  settingsLightbox: JST['contact_manager/settings/settings_lightbox']
  phoneLightbox: JST['contact_manager/phone_lightbox']
  mergeLightbox: JST['contact_manager/merge_lightbox']

  render: ->
    $(@el).html(@template())
    $(@el).append(@settingsLightbox())
    $(@el).append(@phoneLightbox())
    $(@el).append(@mergeLightbox())
    sidebarView = new RippleApp.Views.Sidebar()
    $('#view-sidebar', @el).html(sidebarView.render().el)
   
   
    mailboxView = new RippleApp.Views.Mailbox(
      collection: RippleApp.contactsRouter.notifications
    )
    $('#mailbox').html(mailboxView.render().el)   
    
    userMenuView = new RippleApp.Views.UserMenu(     
    )
    $('#user-menu').html(userMenuView.render().el)
    
    @

  setContextView: (view) ->
    $('#view-context', @el).html(view.render().el)

  setMainView: (view) ->
    $('#view-main', @el).html(view.render().el)
