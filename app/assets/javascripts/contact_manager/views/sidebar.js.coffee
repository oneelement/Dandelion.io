class RippleApp.Views.Sidebar extends Backbone.View
  template: JST['contact_manager/sidebar']

  initialize: ->
    @recentContactsView = new RippleApp.Views.RecentContacts(
      collection: RippleApp.contactsRouter.recentContacts
    )

  render: ->
    $(@el).html(@template())
    $('#recent-contacts', @el).html(@recentContactsView.render().el)
    @delegateEvents()
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
