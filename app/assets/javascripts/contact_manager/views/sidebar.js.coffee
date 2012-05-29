class RippleApp.Views.Sidebar extends Backbone.View
  template: JST['contact_manager/sidebar']
  
  initialize: ->
    $(window).resize(@.redrawMenu)

  render: ->
    $(@el).html(@template())
    
    @recentContactsView = new RippleApp.Views.RecentContacts(
      collection: RippleApp.contactsRouter.recentContacts
    )
    $('#recent-contacts', @el).html(@recentContactsView.render().el)
    @delegateEvents()
    
    @currentUser = new RippleApp.Models.User()
    @currentUser = @currentUser.fetchCurrent(success: (model) =>
      @favouriteContactsView = new RippleApp.Views.FavouriteContacts(
        collection: RippleApp.contactsRouter.favouriteContacts
      )
      $('ul#favourite-menu div#favourites', @el).html(@favouriteContactsView.render().el)
      @.redrawMenu()
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
    menuWidth = 800#$('ul#favourite-menu li').width()
    $('div#favourites', @el).stop().animate({'marginLeft':(74-(menuWidth))+'px'},1600)
    $('#favourite-menu > li', @el).hover(
      () ->
        $('div#favourites',$(@)).stop().animate({'marginLeft':(windowWidth-804)+'px'},600)
      ,
      () ->
        $('div#favourites',$(@)).stop().animate({'marginLeft':(74-(menuWidth))+'px'},600)  
    )