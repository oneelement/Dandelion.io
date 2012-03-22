class TaskManager.Views.Task extends Backbone.View

  template: JST['task_manager/tasks/task']
  tagName:  "li"
  
  initialize: ->
    @model.on('change', @render, this)
    @render()
  
  events:
    'click .task-complete': 'toggleComplete'
    'click span.task-destroy': 'clearTask'
    'dblclick span.task-title': 'editTaskTitle'
    'dblclick span.task-content': 'editTaskContent'
    'keypress #edit_task_title': 'updateOnEnter'
    'keypress #edit_task_content': 'updateOnEnter'
  
  render: ->
    this.model.user = new TaskManager.Models.User(this.model.get('user'))
    #this.model.setUser(new TaskManager.Models.User(this.model.get("user")))
    $(@el).html(@template(task: @model))
    this
    
  toggleComplete: (event) ->
    this.model.toggle()
    if ($(this.el).hasClass('checked'))
      $(this.el).removeClass('checked')
    else
      $(this.el).addClass('checked')
      
  
  
     # if ($('input#check').hasClass('checked')) 
        #this.$('input#check').removeClass('checked')
        #$(this.el).removeClass('working')
      #else 
        #this.$('input#check').addClass('checked')
       #$(this.el).addClass('working')
    
  #this.$('input#check').change -> this.$('input#check').addClass('checked'), -> this.$('input#check').removeClass('checked')

    
  clearTask: ->
    this.model.destroy()
    
  editTaskTitle: ->
    $(this.el).addClass('editing')
    this.$('input#edit_task_title').focus()
    
  editTaskContent: ->
    $(this.el).addClass('editing')
    this.$('input#edit_task_content').focus()
    
  updateOnEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      this.close()
  
  close: ->
    this.model.save title: this.$('input#edit_task_title').val(), content: this.$('input#edit_task_content').val()
    $(this.el).removeClass('editing')