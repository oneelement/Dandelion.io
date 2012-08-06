window.RippleApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Lib: {}
  init: ->
    @contactsRouter = new RippleApp.Routers.Contacts()
    #@tasksRouter = new RippleApp.Routers.Tasks()

    @layout = new RippleApp.Views.Layout()
    $('#container').html(@layout.render().el)

    Backbone.history.start()

$(document).ready ->
  RippleApp.init()
  
