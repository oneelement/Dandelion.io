class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "": "home"
    "contacts": "index"
    "contacts/show/:id": "show"
    "contacts/preview/:id": "preview"
    "contacts/new": "new"

  initialize: ->
    @currentUser = new RippleApp.Models.User()
    @contacts = new RippleApp.Collections.Contacts()
    @recentContacts = new RippleApp.Collections.Contacts()
    return @
    
  home: ->
    after = (contact) =>
      @setContextContact(contact)   
    
    #im thinking this could be incorporated into the logic below, i dont get the isNew bit as I though
    #the user model will always have been saved to the server. DA to clarify. OC
    @currentUser.fetchCurrent(success: (model) =>
      view = new RippleApp.Views.HomePage(model: model)
      RippleApp.layout.setMainView(view)
    )    

    if @currentUser.isNew()
      @currentUser.fetchCurrent(success: (model) =>
        @getContact(model.get("contact_id"), after)
      )

    else
      @getContact(@currentUser.id, after)

  index: ->
    @contacts.fetch(
      success: =>
        view = new RippleApp.Views.ContactsIndex(collection: @contacts)
        RippleApp.layout.setMainView(view)
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
    view = new RippleApp.Views.ContactCard(model: @_contextContact)
    RippleApp.layout.setContextView(view)

  showContact: (contact) ->
    showView = new RippleApp.Views.ContactsShow(model: contact)
    RippleApp.layout.setMainView(showView)
