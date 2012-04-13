class ContactManager.Views.ContactsIndex extends Backbone.View
  template: JST['contact_manager/contact_index']
  id: 'contacts-overview'
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)
    #@contactSearch()
    @newContact()

    @contactsTree = new ContactManager.Views.ContactsTree(collection: @options.treeCollection)
    $('#contact-tree').append(@contactsTree.render().el)

  render: ->
    $(@el).html(@template())        
    @collection.each(@appendContact)
    this
  
  contactSearch: ->
    view = new ContactManager.Views.ContactsSearch(model: @model)
    $('#sitewide-search').append(view.render().el)
    
  newContact: ->
    view = new ContactManager.Views.ContactNew(model: @model)
    $('#contact-modal').append(view.render().el)
    
  appendObsolete: (contact) =>
    view = new ContactManager.Views.ContactsShow(model: contact)
    $('#contact-profiles').append(view.render().el)
    
  appendContact: (contact) =>
    view = new ContactManager.Views.ContactsList(model: contact)
    $('#contacts-overview').append(view.render().el)
