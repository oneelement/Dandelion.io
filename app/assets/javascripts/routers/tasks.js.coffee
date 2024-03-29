class RippleApp.Routers.Tasks extends Backbone.Router
  routes:
    'tasks': 'index'
    
  initialize: ->
    @collection = new RippleApp.Collections.Tasks()
    @collection.fetch()
    
  index: ->
    view = new RippleApp.Views.TasksIndex(collection: @collection)
    RippleApp.layout.setMainView(view)

