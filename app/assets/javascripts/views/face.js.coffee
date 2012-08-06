class RippleApp.Views.Face extends Backbone.View
  template: JST['contact_manager/face']
  tagName: 'li'
  className: 'face'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(face: @model.toJSON()))
    this


