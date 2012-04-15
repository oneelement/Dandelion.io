class RippleApp.Views.ContactsIndex extends Backbone.View
  template: JST['contact_manager/contact_index']
  id: 'contacts-index'
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendContact)
    @
  
  contactSearch: ->
    view = new RippleApp.Views.ContactsSearch(model: @model)
    $('#sitewide-search').append(view.render().el)
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact)
    @$el.append(view.render().el)
