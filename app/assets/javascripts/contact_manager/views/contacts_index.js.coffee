class ContactManager.Views.ContactsIndex extends Backbone.View
  template: JST['contact_manager/contact_index']
  id: 'contacts-overview'
  
  initialize: ->
    @collection.on('reset', @render, this) 
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->
    $(@el).html(@template())
    #@populateTree()
    @newContact()
    @collection.each(@appendContact)
    this
    
  newContact: ->
    view = new ContactManager.Views.ContactNew(model: @model)
    $('#contact-modal').append(view.render().el)
    
  populateTree: (contact) =>
    view = new ContactManager.Views.ContactsTree(model: contact)
    $('ul.nav-contact-tree').append(view.render().el)

  appendObsolete: (contact) =>
    view = new ContactManager.Views.ContactsShow(model: contact)
    $('#contact-profiles').append(view.render().el)
    
  appendContact: (contact) =>
    view = new ContactManager.Views.ContactsList(model: contact)
    $('#contacts-overview').append(view.render().el)
