class TaskManager.Views.UsersIndex extends Backbone.View

  template: JST['task_manager/users/index']
  tagName: "select"
  id: "new_task_id"
  
  initialize: ->
    @collection = new TaskManager.Collections.Users()
    @collection.fetch()
    @collection.on('reset', @render, this)
  
  render: ->
    $(@el).html(@template(users: @collection))
    this
