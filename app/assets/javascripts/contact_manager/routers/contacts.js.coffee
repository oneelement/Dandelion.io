class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "": "index"
    "contacts": "indexContact"
    "contacts/show/:id": "show"
    "contacts/new": "new"

  initialize: ->
    @collection = new RippleApp.Collections.Contacts()
    @recentContacts = new RippleApp.Collections.Contacts()
    @view = new RippleApp.Views.ContactsIndex(collection: @collection)
    return @
    
  index: ->
    currentuser = new RippleApp.Models.Currentuser()
    currentuser.fetch(success: (currentuser, response) =>
      contact_id = response.contact_id
      @homeContact = new RippleApp.Models.Contact({_id: contact_id})
      @homeContact.fetch(success: (response) =>
        @setContextContact(@homeContact)
      )
    )

  indexContact: ->
    @collection.fetch(
      success:
        RippleApp.layout.setMainView(@view)
    )
  
  new: ->
    view = new RippleApp.Views.ContactNew()
    $('#contact-modal', @el).html(view.render().el)
  
  show: (id) ->
    @_contextContact = @recentContacts.get(id)

    if not @_contextContact?
      @_contextContact = new RippleApp.Models.Contact({_id: id})

      @_contextContact.fetch(success: (model) =>
        @recentContacts.add(model)
        @setContextContact(model)
        @showContact(model)
      )
    else
        @setContextContact(@_contextContact)
        @showContact(@_contextContact)

  contextContact: ->
    if @_contextContact?
      return @_contextContact
    else
      return null

  setContextContact: (contact) ->
    @_contextContact = contact
    view = new RippleApp.Views.Contact(model: @_contextContact)
    RippleApp.layout.setContextView(view)

  showContact: (contact) ->
    showView = new RippleApp.Views.ContactsShow(model: contact)
    RippleApp.layout.setMainView(showView)
