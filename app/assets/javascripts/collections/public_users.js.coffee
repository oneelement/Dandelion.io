class RippleApp.Collections.PublicUsers extends Backbone.Collection
  model: RippleApp.Models.PublicUser
  
  initialize: (models, options) ->
    this.query = options.query
    this.call = options.call
    
  url: ->
    '/public_users/' + this.call
    
  #parse: (data) ->
    #data.results