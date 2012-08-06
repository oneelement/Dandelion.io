class RippleApp.Collections.Linkedins extends Backbone.Collection
  model: RippleApp.Models.Linkedin
  #url: '/twitter_feeds'
  
  initialize: (models, options) ->
    this.query = options.query
    this.call = options.call
    
  url: ->
    '/linkedin_feeds/' + this.call
    
  #parse: (data) ->
    #data.results