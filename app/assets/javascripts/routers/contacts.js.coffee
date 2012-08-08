class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "": "home"
    "contacts": "index"
    "contacts/show/:id": "show"
    "contacts/preview/:id": "preview"
    "contacts/new": "new"
    "groups": "groupindex"
    "groups/show/:id": "groupShow"
    "hashtags/show/:id": "hashtagShow"
    "users/preview/:id": "userPreview"

  initialize: ->
    @globalTweets = new RippleApp.Collections.GlobalTweets()
    @globalFaces = new RippleApp.Collections.GlobalFaces()
    @currentUser = new RippleApp.Models.User()
    @recentContacts = new RippleApp.Collections.ContactBadges(maxSize: 5)
    @favouriteContacts = new RippleApp.Collections.ContactBadges()    
    @currentUser.fetchCurrent(success: (user) =>
      @currentUser = user
      #This will clear down your fav and recent contacts, if you're having problems due to favourite bug
      #@currentUser.set('favourite_contacts', '[]')
      #@currentUser.set('favourite_contacts', '[]')
      #@currentUser.save()
      @recentContacts.add(JSON.parse(user.get('recent_contacts')))
      @favouriteContacts.add(JSON.parse(user.get('favourite_contacts')))
    )
    @contacts = new RippleApp.Collections.Contacts()  
    @contacts.fetch() #OC fetching contacts just once on init, then all others are added to the collection.
    @groups = new RippleApp.Collections.Groups()
    @groups.fetch()
    @groupContacts = new RippleApp.Collections.Contacts()
    @hashtags = new RippleApp.Collections.Hashtags()
    @hashtags.fetch()
    
    @userContacts = new RippleApp.Collections.UserContacts()
    @userContacts.fetch()
    
    @notifications = new RippleApp.Collections.Notifications()
    @notifications.fetch()
    setInterval (=> 
      @notifications.fetch()        
    ), 60000
    
    @

    
  home: ->
    after = (contact) =>
      tweets = @globalTweets.get(@currentUser.get('_id'))
      faces = @globalFaces.get(@currentUser.get('_id'))
      viewHome = new RippleApp.Views.HomePage(model: @currentUser, contact: contact, globalTweets: @globalTweets, globalFaces: @globalFaces, tweets: tweets, faces: faces)
      RippleApp.layout.setMainView(viewHome)
      @setContextContact(contact)
    
    user = @currentUser.get("_id")   
    if not user?   
      @currentUser.fetchCurrent(success: (model) =>
        id = model.get("contact_id")
        console.log(id)
        @getContact(id, after)
      )    
    else     
      id = @currentUser.get("contact_id")
      @getContact(id, after) 

  index: ->
    view = new RippleApp.Views.ContactsIndex(collection: @contacts, favorites: @favouriteContacts)
    RippleApp.layout.setMainView(view)
    viewContext = new RippleApp.Views.AddContactCard(model: new RippleApp.Models.Contact())
    RippleApp.layout.setContextView(viewContext)
    
  groupindex: ->
    view = new RippleApp.Views.GroupsIndex(collection: @groups)
    RippleApp.layout.setMainView(view)
    viewContext = new RippleApp.Views.AddContactCard(model: new RippleApp.Models.Group())
    RippleApp.layout.setContextView(viewContext)
    
  groupShow: (id) ->
    after = (group) =>
      @setContextContact(group)
      @showGroup(group)
      @groups.add(group) #OC added so new contacts are added to the collection and we dont have to fetch from the server

    @getGroup(id, after)

  hashtagShow: (id) ->
    hashtag = @hashtags.get(id)
    view = new RippleApp.Views.HashtagCard(model: hashtag)
    RippleApp.layout.setContextView(view)
    
    tagContacts = new RippleApp.Collections.Contacts()
    _.each(hashtag.get('contact_ids'), (contact_id)=>
      tagContacts.add(@contacts.get(contact_id))
    )
    
    view = new RippleApp.Views.ContactsIndex(collection: tagContacts)
    RippleApp.layout.setMainView(view)
    
  userPreview: (id) ->        
    #insert loading view here

    current_user = @currentUser
    user = new RippleApp.Models.PublicUser({_id: id})
    user.fetch(success: (user) ->
      user_contact_id = user.get('contact_id')
      
      contact = new RippleApp.Models.PublicContact({_id: user_contact_id})
      contact.fetch(success: (contact) ->
        viewContext = new RippleApp.Views.UserCard(model: contact, current_user: current_user, target_user: user)
        RippleApp.layout.setContextView(viewContext)
      )
    )
    

  #Display the contact, and full detail in the main view
  show: (id) ->
    @getContact(id, (contact) =>
      @recentContacts.add(contact.getBadge())  
      @currentUser.set('recent_contacts', JSON.stringify(@recentContacts.getTop5()))
      @currentUser.save()
      @setContextContact(contact)
      @showContact(contact)
      @contacts.add(contact) #OC added so new contacts are added to the collection and we dont have to fetch from the server
    )
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
        view = new RippleApp.Views.ContactShow(model: contact, user: model, globalTweets: @globalTweets, globalFaces: @globalFaces)
        RippleApp.layout.setMainView(view)
      )
    else
      view = new RippleApp.Views.ContactShow(model: contact, user: @currentUser, globalTweets: @globalTweets, globalFaces: @globalFaces)
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