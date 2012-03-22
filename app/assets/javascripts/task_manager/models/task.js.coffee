class TaskManager.Models.Task extends Backbone.RelationalModel
  #urlRoot: -> '/api/users'

  initialize: ->
    #this.user = new Crm.Models.User(this.get('user'))
    if this.has "user"
      this.setUser(new Crm.Models.User(this.get("user")))

  setUser: (user) ->
    this.user = user
  
  toggle: ->
    this.save complete: not this.get "complete"