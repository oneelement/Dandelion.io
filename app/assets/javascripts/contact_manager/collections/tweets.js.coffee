class RippleApp.Collections.Tweets extends Backbone.Collection
  model: RippleApp.Models.Tweet
  
  initialize: (models, options) ->
    this.query = options.query
    
  url: ->
    "http://search.twitter.com/search.json?q=" + this.query + "&callback=?"
    
  parse: (data) ->
    data.results