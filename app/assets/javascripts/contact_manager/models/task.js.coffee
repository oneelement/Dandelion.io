class RippleApp.Models.Task extends Backbone.RelationalModel
  #urlRoot: -> '/api/users'
  idAttribute: '_id'

  initialize: ->
    #this.user = new Crm.Models.User(this.get('user'))
    if this.has "user"
      this.setUser(new RippleApp.Models.User(this.get("user")))

  setUser: (user) ->
    this.user = user
  
  toggle: ->
    this.save complete: not this.get "complete"
