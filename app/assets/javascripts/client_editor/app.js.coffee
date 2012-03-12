window.ClientEditor =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new ClientEditor.Routers.Contacts()
    Backbone.history.start({pushState: true})

$(document).ready ->
  ClientEditor.init()
