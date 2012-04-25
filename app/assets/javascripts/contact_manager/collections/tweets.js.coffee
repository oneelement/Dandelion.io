class RippleApp.Collections.Tweets extends Backbone.Collection
  model: RippleApp.Models.Tweet
  url: '/twitter_feeds'
  
  #initialize: (models, options) ->
    #this.query = options.query
    #this.url = options.url
    
  #url: ->
    #"http://localhost:3000/twitter_feeds" #this.url
    
  #parse: (data) ->
    #data.results