class TaskManager.Routers.Tasks extends Backbone.Router
  routes:
    '': 'index'
    
  initialize: ->
    @collection = new TaskManager.Collections.Tasks()
    @collection.fetch()
    
  index: ->
    view = new TaskManager.Views.TasksIndex(collection: @collection)
    $('#container').html(view.render().el)