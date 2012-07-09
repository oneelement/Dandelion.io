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
      $('#favorite-container', @el).html(@favouriteContactsView.render().el)
      #@.redrawMenu()
    )
    @isVisible = false
        
    @

  events:
    "click #sidebar-home": "clickHome"
    "click #sidebar-contacts": "clickContacts"
    "click #sidebar-groups": "clickGroups"
    "click #favorite-menu": "showFavorites"

  clickHome: ->
    this.$('#sidebar-contacts').removeClass('active')
    this.$('#sidebar-groups').removeClass('active')
    this.$('#sidebar-home').addClass('active')
    Backbone.history.navigate('#', true)

  clickContacts: ->
    this.$('#sidebar-contacts').addClass('active')
    this.$('#sidebar-groups').removeClass('active')
    this.$('#sidebar-home').removeClass('active')
    Backbone.history.navigate('#contacts', true)

    
  clickGroups: ->
    this.$('#sidebar-contacts').removeClass('active')
    this.$('#sidebar-groups').addClass('active')
    this.$('#sidebar-home').removeClass('active')
    Backbone.history.navigate('#groups', true)
    
  showFavorites: ->
    console.log('log')
    if @isVisible == false
      @isVisible = true
      this.$('#favorite-container').css('display','block')
      this.$('#favorite-caret').css('display','block')
    else
      this.$('#favorite-container').css('display','none')
      this.$('#favorite-caret').css('display','none')
      @isVisible = false

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