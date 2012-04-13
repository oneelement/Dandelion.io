class RippleApp.Views.Sidebar extends Backbone.View
  template: JST['contact_manager/sidebar']

  initialize: ->
    @recentContactsView = new RippleApp.Views.RecentContacts(
      collection: RippleApp.contactsRouter.recentContacts
    )

  render: ->
    @$el.html(@template())
    $('#recent-contacts', @el).html(@recentContactsView.render().el)
    @

  events:
    "click #sidebar-home": "clickHome"
    "click #sidebar-contacts": "clickContacts"
    "click #sidebar-tasks": "clickTasks"

  clickHome: ->
    Backbone.history.navigate('#', true)

  clickContacts: ->
    Backbone.history.navigate('#contacts', true)

  clickTasks: ->
    Backbone.history.navigate('#tasks', true)
