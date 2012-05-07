class RippleApp.Collections.Faces extends Backbone.Collection
  model: RippleApp.Models.Face
  #url: '/twitter_feeds'
  
  initialize: (models, options) ->
    this.query = options.query
    this.call = options.call
    
  url: ->
    '/facebook_feeds/' + this.call
    
  #parse: (data) ->
    #data.results