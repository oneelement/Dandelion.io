window.TaskManager =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new TaskManager.Routers.Tasks()
    Backbone.history.start()

$(document).ready ->
  TaskManager.init()
