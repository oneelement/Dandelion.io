class ContactManager.Views.ContactsShow extends Backbone.View
  template: JST['contact_manager/contact_show']
  className: 'contact-inactive'  
  
  initialize: ->
    @model.on('change', @render, this)

  render: ->
    this.model.addresses = new ContactManager.Collections.Contacts(this.model.get('addresses'))
    this.model.phones = new ContactManager.Collections.Contacts(this.model.get('phones'))
    #this.model.phones = new ContactManager.Collections.Phones(this.model.get('phones'))
    #this.model.address = new ContactManager.Models.Address(this.model.get('address'))
    #myphones = this.model.get("phones")
    $(@el).html(@template(contact: @model))
    return this

