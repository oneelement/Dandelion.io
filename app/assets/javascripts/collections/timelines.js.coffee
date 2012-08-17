class RippleApp.Collections.Timelines extends Backbone.Collection
  model: RippleApp.Models.TimelineEntry
  #url: '/twitter_feeds'
  
  initialize: (models, options) ->
    this.query = options.query
    this.call = options.call
    
  url: ->
    '/timelines/' + this.call
    
  #parse: (data) ->
    #data.results