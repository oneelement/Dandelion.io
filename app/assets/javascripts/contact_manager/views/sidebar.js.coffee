class RippleApp.Views.Sidebar extends Backbone.View
  template: JST['contact_manager/sidebar']
  favouriteItem: JST['contact_manager/contact_badge']

  initialize: ->
    $(window).resize(@.redrawMenu)

  render: ->
    $(@el).html(@template())
    @recentContactsView = new RippleApp.Views.RecentContacts(
      collection: RippleApp.contactsRouter.recentContacts
    )
    $('#recent-contacts', @el).html(@recentContactsView.render().el)
    @delegateEvents()
    
    #set up the favourite slide out menu
    @contacts = new RippleApp.Collections.Contacts()
    @contacts.fetch(success: () =>
      @currentUser = new RippleApp.Models.User()
      @currentUser = @currentUser.fetchCurrent(success: (model) =>
        @currentUser = model
        favourite_ids = @currentUser.get('favorite_ids')
        _.each(favourite_ids, (contact_id)=>
          contact = @contacts.get(contact_id)
          $('div#favourites', @el).append(@favouriteItem(model: contact.toJSON()))
        )
        @.redrawMenu()
      )
    )
    @

  events:
    "click #sidebar-home": "clickHome"
    "click #sidebar-contacts": "clickContacts"
    "click #sidebar-groups": "clickGroups"
    "click #sidebar-tasks": "clickTasks"

  clickHome: ->
    Backbone.history.navigate('#', true)

  clickContacts: ->
    Backbone.history.navigate('#contacts', true)

  clickTasks: ->
    Backbone.history.navigate('#tasks', true)
    
  clickGroups: ->
    Backbone.history.navigate('#groups', true)

  redrawMenu: =>
    windowWidth = $(window).width()
    menuWidth = $('ul#favourite-menu li').width()
    $('div#favourites', @el).stop().animate({'marginLeft':(68-(menuWidth+402))+'px'},1000)
    $('#favourite-menu > li', @el).hover(
      () ->
        $('div#favourites',$(@)).stop().animate({'marginLeft':(windowWidth-100)+'px'},200)
      ,
      () ->
        $('div#favourites',$(@)).stop().animate({'marginLeft':(65-(menuWidth+402))+'px'},200)  
    )