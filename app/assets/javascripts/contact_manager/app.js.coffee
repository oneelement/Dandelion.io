window.ContactManager =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new ContactManager.Routers.Contacts()
    Backbone.history.start()

$(document).ready ->
  ContactManager.init()
