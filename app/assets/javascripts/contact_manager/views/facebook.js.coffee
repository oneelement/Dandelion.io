class RippleApp.Views.Facebook extends Backbone.View
  template: JST['contact_manager/facebook']
  tagName: 'ul'
  id: 'faces'
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)
  
  render: =>    
    $(@el).html(@template)
    @collection.each(@appendFace) 
    this    
  
  appendFace: (face) =>
    view = new RippleApp.Views.Face(model: face)
    $(this.el).append(view.render().el)  



