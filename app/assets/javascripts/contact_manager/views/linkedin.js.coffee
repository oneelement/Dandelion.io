class RippleApp.Views.Linkedin extends Backbone.View
  template: JST['contact_manager/linkedin']
    
  render: =>    
    $(@el).html(@template)
    @collection.each(@appendLinkedin) 
    this    
  
  appendLinkedin: (link) ->
    view = new RippleApp.Views.Linked(model: link)
    $('#linkedins').append(view.render().el)  



