class RippleApp.Views.Facebook extends Backbone.View
  template: JST['contact_manager/facebook']
    
  render: =>    
    $(@el).html(@template)
    @collection.each(@appendFace) 
    this    
  
  appendFace: (face) ->
    view = new RippleApp.Views.Face(model: face)
    $('#faces').append(view.render().el)  



