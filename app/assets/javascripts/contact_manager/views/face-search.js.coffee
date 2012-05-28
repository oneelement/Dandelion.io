class RippleApp.Views.FaceSearch extends Backbone.View
  template: JST['contact_manager/face_search_item']
  tagName: 'li'
  className: 'face-search'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(face: @model.toJSON()))
    this


