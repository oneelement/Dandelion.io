class RippleApp.Views.Linked extends Backbone.View
  template: JST['contact_manager/linked']
  tagName: 'li'
  #className: 'link'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(link: @model.toJSON()))
    this


