class RippleApp.Collections.Mergers extends Backbone.Collection
  model: RippleApp.Models.Merger
  #url: '/twitter_feeds'
  
  initialize: (models, options) ->
    this.query = options.query
    this.call = options.call
    
  url: ->
    '/contacts/multiplemerge/' + this.call
    
  #parse: (data) ->
    #data.results