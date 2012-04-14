class RippleApp.Views.ContactsIndex extends Backbone.View
  template: JST['contact_manager/contact_index']
  id: 'contacts-overview'
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)
    #@contactSearch()
    @newContact()

  render: ->
    @$el.html(@template())
    @newContact()
    @collection.each(@appendContact)
    @
  
  contactSearch: ->
    view = new RippleApp.Views.ContactsSearch(model: @model)
    $('#sitewide-search').append(view.render().el)
    
  newContact: ->
    view = new RippleApp.Views.ContactNew(model: @model)
    $('#test').append(view.render().el)
    
  appendObsolete: (contact) =>
    view = new RippleApp.Views.ContactsShow(model: contact)
    $('#contact-profiles', @el).append(view.render().el)
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact)
    $('#contacts-overview', @el).append(view.render().el)
