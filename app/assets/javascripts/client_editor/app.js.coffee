window.ClientEditor =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    @router = new ClientEditor.Routers.Contacts()
    Backbone.history.start()

$(document).ready ->
  ClientEditor.init()
