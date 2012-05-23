class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "": "home"
    "contacts": "index"
    "contacts/show/:id": "show"
    "contacts/preview/:id": "preview"
    "contacts/new": "new"
    "groups": "groupindex"
    "groups/show/:id": "groupShow"

  initialize: ->
    @currentUser = new RippleApp.Models.User()
    @recentContacts = new RippleApp.Collections.RecentContacts()
    @contacts = new RippleApp.Collections.Contacts()
    @contacts.fetch() #OC fetching contacts just once on init, then all others are added to the collection.
    @groups = new RippleApp.Collections.Groups()
    @groups.fetch()
    return @
    
  home: ->
    #after = (contact) =>
      #@setContextContact(contact) 
    
    after = (contact) =>
      viewHome = new RippleApp.Views.HomePage(model: @currentUser, contact: contact)
      RippleApp.layout.setMainView(viewHome)
      @setContextContact(contact)
    
    user = @currentUser.get("_id")   
    if not user?   
      @currentUser.fetchCurrent(success: (model) =>
        id = model.get("contact_id")
        @getContact(id, after)
      )    
    else     
      id = @currentUser.get("contact_id")
      @getContact(id, after) 
    
#    OC trying to reduce server calls
#    if @currentUser.isNew()
#      @currentUser.fetchCurrent(success: (model) =>
#        @getContact(model.get("contact_id"), after)
#      )
#      
#    else
#      @getContact(@currentUser.id, after)

  index: ->
    view = new RippleApp.Views.ContactsIndex(collection: @contacts)
    RippleApp.layout.setMainView(view)
    
  groupindex: ->
    view = new RippleApp.Views.GroupsIndex(collection: @groups)
    RippleApp.layout.setMainView(view)
    
  groupShow: (id) ->
    after = (group) =>
      @setContextContact(group)
      @showGroup(group)
      @groups.add(group) #OC added so new contacts are added to the collection and we dont have to fetch from the server

    @getGroup(id, after)
  
  #Display the contact, and full detail in the main view
  show: (id) ->
    after = (contact) =>
      #@recentContacts.add(contact)
      #if @recentContacts.length > @recentContacts.maxSize
        #first = @recentContacts.at(0)
        #@recentContacts.remove(first)
        #@recentContacts.reset(@recentContacts.models)
        #console.log(first)
      @setContextContact(contact)
      @showContact(contact)
      @contacts.add(contact) #OC added so new contacts are added to the collection and we dont have to fetch from the server

    @getContact(id, after)

  #Display the contact card, without full detail
  preview: (id) ->
    after = (contact) =>
      @setContextContact(contact)

    @getContact(id, after)

  #get the contact
  getContact: (id, after) ->
    contact = @contacts.get(id)

    if not contact?
      contact = new RippleApp.Models.Contact({_id: id})
      contact.fetch(success: after)
    else
      after(contact)
      
  getGroup: (id, after) ->
    group = @groups.get(id)

    if not group?
      group = new RippleApp.Models.Group({_id: id})
      group.fetch(success: after)
    else
      after(group)


  contextContact: ->
    if @_contextContact?
      return @_contextContact
    else
      return null

  setContextContact: (contact) ->
    @_contextContact = contact
    user = @currentUser.get("_id")
    if not user?
      @currentUser.fetchCurrent(success: (model) =>
        view = new RippleApp.Views.ContactCard(model: @_contextContact, user: model)
        RippleApp.layout.setContextView(view)
      )
    else
      view = new RippleApp.Views.ContactCard(model: @_contextContact, user: @currentUser)
      RippleApp.layout.setContextView(view)

  showContact: (contact) ->
    user = @currentUser.get("_id")
    if not user?
      @currentUser.fetchCurrent(success: (model) =>
        view = new RippleApp.Views.ContactShow(model: contact, user: model)
        RippleApp.layout.setMainView(view)
      )
    else
      view = new RippleApp.Views.ContactShow(model: contact, user: @currentUser)
      RippleApp.layout.setMainView(view)
      
  showGroup: (group) ->
    user = @currentUser.get("_id")
    if not user?
      @currentUser.fetchCurrent(success: (model) =>
        view = new RippleApp.Views.GroupShow(model: group, user: model)
        RippleApp.layout.setMainView(view)
      )
    else
      view = new RippleApp.Views.GroupShow(model: group, user: @currentUser)
      RippleApp.layout.setMainView(view)