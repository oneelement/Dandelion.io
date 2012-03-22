class TaskManager.Collections.Tasks extends Backbone.Collection
  model: TaskManager.Models.Task
  url: '/tasks'