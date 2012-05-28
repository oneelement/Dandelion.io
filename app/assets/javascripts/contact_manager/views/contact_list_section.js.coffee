class RippleApp.Views.ContactListSection extends Backbone.View
  template: JST['contact_manager/contact_list_section']
  className: 'contact-list-section'

  initialize: ->
    @collection.on('add', @render, this)
    @collection.on('reset', @render, this)


  render: ->
    $(@el).html(@template())
    return this
    
 