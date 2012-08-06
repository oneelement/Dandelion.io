class RippleApp.Views.ContactListDetail extends Backbone.View
  template: JST['contact_manager/contact_details/contact_list_detail']
  
  initialize: ->    
    @model.on('change', @render, this)
    @field = @model.getFieldName()
    @icon = @model.getViewIcon()

  render: ->
    $(@el).html(@template(icon: @icon, value: @model.get(@field)))
    @
    

