class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  
  initialize: ->
    #@model.on('change', @render, this)
  
  render: ->
    #this.model.addresses = new RippleApp.Collections.Contacts(this.model.get('addresses'))
    #this.model.phones = new RippleApp.Collections.Contacts(this.model.get('phones'))
    $(@el).html(@template)
    return this
  

