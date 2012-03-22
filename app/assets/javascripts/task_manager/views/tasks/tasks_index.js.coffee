class TaskManager.Views.TasksIndex extends Backbone.View

  template: JST['task_manager/tasks/index']
  id: "home"
  
  events:
    'submit #new_task': 'createTask'
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)
  
  render: ->
    $(@el).html(@template())
    @appendUser()
    @collection.each(@appendTask)
    this
    
  appendUser: ->
    view = new TaskManager.Views.UsersIndex()
    $('#task_user').append(view.render().el)
    
  appendTask: (task) ->
    view = new TaskManager.Views.Task(model: task)
    $('#tasks').append(view.render().el)
    
  createTask: (event) ->
    event.preventDefault()
    @collection.create title: $('#new_task_title').val(), content: $('#new_task_content').val(), user_id: $('#new_task_id').val()