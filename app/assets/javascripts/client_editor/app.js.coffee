window.ClientEditor =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new ClientEditor.Routers.Contacts()
    Backbone.history.start()

$(document).ready ->
  ClientEditor.init()
