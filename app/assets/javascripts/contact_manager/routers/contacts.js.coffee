class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "": "index"
    "contacts": "indexContact"
    "contacts/show/:id": "show"
    "contacts/preview/:id": "preview"
    "contacts/new": "new"

  initialize: ->
    @contacts = new RippleApp.Collections.Contacts()
    @recentContacts = new RippleApp.Collections.Contacts()
    @view = new RippleApp.Views.ContactsIndex(collection: @contacts)
    return @
    
  index: ->
    currentuser = new RippleApp.Models.Currentuser()
    currentuser.fetch(success: (currentuser, response) =>
      after = (contact) =>
        @setContextContact(contact)

      @getContact(response.contact_id, after)
    )

  indexContact: ->
    @contacts.fetch(
      success: =>
        RippleApp.layout.setMainView(@view)
    )
  
  new: ->
    view = new RippleApp.Views.ContactNew()
    $('#contact-modal', @el).html(view.render().el)
  
  #Display the contact, and full detail in the main view
  show: (id) ->
    after = (contact) =>
      @recentContacts.add(contact)
      @setContextContact(contact)
      @showContact(contact)

    @getContact(id, after)

  #Display the contact card, without full detail
  preview: (id) ->
    after = (contact) =>
      @setContextContact(contact)

    @getContact(id, after)

  getContact: (id, after) ->
    contact = @contacts.get(id)

    if not contact?
      contact = new RippleApp.Models.Contact({_id: id})
      contact.fetch(success: after)
    else
      after(contact)

  contextContact: ->
    if @_contextContact?
      return @_contextContact
    else
      return null

  setContextContact: (contact) ->
    @_contextContact = contact
    view = new RippleApp.Views.ContactProfile(model: @_contextContact)
    RippleApp.layout.setContextView(view)

  showContact: (contact) ->
    showView = new RippleApp.Views.ContactsShow(model: contact)
    RippleApp.layout.setMainView(showView)
