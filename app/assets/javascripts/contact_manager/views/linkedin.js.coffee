class RippleApp.Views.Linkedin extends Backbone.View
  template: JST['contact_manager/linkedin']
    
  render: =>    
    $(@el).html(@template(linkedin: @model.toJSON()))
    this    
  



