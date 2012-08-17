class RippleApp.Views.FacebookComment extends Backbone.View
  template: JST['contact_manager/facebook_comment']
  className: 'comment-item'
  tagName: 'li'
    
  render: ->    
    $(@el).html(@template(comment: @model.toJSON()))
    
   
    return this   
    
     
