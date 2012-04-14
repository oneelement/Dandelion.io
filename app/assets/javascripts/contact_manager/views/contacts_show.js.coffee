class RippleApp.Views.ContactsShow extends Backbone.View
  template: JST['contact_manager/contact_show']
  className: 'contact-inactive'
  
  initialize: ->
    @model.on('change', @render, this)

  render: ->
    this.model.addresses = new RippleApp.Collections.Contacts(this.model.get('addresses'))
    this.model.phones = new RippleApp.Collections.Contacts(this.model.get('phones'))
    #this.model.phones = new RippleApp.Collections.Phones(this.model.get('phones'))
    #this.model.address = new RippleApp.Models.Address(this.model.get('address'))
    #myphones = this.model.get("phones")
    $(@el).html(@template(contact: @model))

    return this
