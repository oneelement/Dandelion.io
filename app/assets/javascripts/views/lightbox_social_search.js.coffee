class RippleApp.Views.LightboxSocialSearch extends Backbone.View
  template: JST['contact_manager/search_modal']
  id: 'social-lightbox'
  
  
  render: ->   
    $(@el).html(@template(contact: @model.toJSON()))   
    
    return this