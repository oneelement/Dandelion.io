class RippleApp.Views.TwitterSearch extends Backbone.View
  template: JST['contact_manager/twitter_search_item']
  tagName: 'li'
  className: 'twitter-search'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(twitter: @model.toJSON()))
    this


