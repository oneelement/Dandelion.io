window.ClientEditor =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
<<<<<<< HEAD
    new ClientEditor.Routers.Contacts()
    Backbone.history.start({pushState: true})
=======
    @router = new ClientEditor.Routers.Contacts()
    Backbone.history.start()
>>>>>>> 25d66bc288015349353b9cf46b5bd5dbb93d8501

$(document).ready ->
  ClientEditor.init()
