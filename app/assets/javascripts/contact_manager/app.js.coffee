window.ContactManager =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    @router = new ContactManager.Routers.Contacts()
    Backbone.history.start()

$(document).ready ->
  ContactManager.init()
