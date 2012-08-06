class RippleApp.Collections.Tweets extends Backbone.Collection
  model: RippleApp.Models.Tweet
  #url: '/twitter_feeds'
  
  initialize: (models, options) ->
    this.query = options.query
    this.call = options.call
    
  url: ->
    '/twitter_feeds/' + this.call
    
  #parse: (data) ->
    #data.results