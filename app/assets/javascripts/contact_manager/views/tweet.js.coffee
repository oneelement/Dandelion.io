class RippleApp.Views.Tweet extends Backbone.View
  template: JST['contact_manager/tweet']
  tagName: 'li'
  #className: 'tweet'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(tweet: @model.toJSON()))
    this


