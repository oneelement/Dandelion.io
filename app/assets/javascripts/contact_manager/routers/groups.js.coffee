class RippleApp.Routers.Groups extends Backbone.Router
  routes:
    "groups": "index"
    "groups/show/:id": "show"

  initialize: ->
    @currentUser = new RippleApp.Models.User()
    @groups = new RippleApp.Collections.Groups()
    @groups.fetch() #OC fetching contacts just once on init, then all others are added to the collection.
    #@recentContacts = new RippleApp.Collections.Contacts()
    #@currentUser.fetchCurrent(success: (model) =>
    #)
    return @

  index: ->
    view = new RippleApp.Views.GroupsIndex(collection: @groups)
    RippleApp.layout.setMainView(view)
  
  
  #Display the contact, and full detail in the main view
  show: (id) ->
    after = (group) =>
      #@recentContacts.add(group)
      @setContextGroup(group)
      @showGroup(group)
      @groups.add(group) #OC added so new contacts are added to the collection and we dont have to fetch from the server

    @getGroup(id, after)

  #Display the contact card, without full detail
  preview: (id) ->
    after = (contact) =>
      @setContextContact(contact)

    @getContact(id, after)

  getGroup: (id, after) ->
    group = @groups.get(id)

    if not group?
      group = new RippleApp.Models.Group({_id: id})
      group.fetch(success: after)
    else
      after(group)

  contextGroup: ->
    if @_contextGroup?
      return @_contextGroup
    else
      return null

  setContextGroup: (group) ->
    @_contextGroup = group
    @currentUser.fetchCurrent(success: (model) =>
      view = new RippleApp.Views.ContactCard(model: @_contextGroup, user: model)
      RippleApp.layout.setContextView(view)
    )

  showGroup: (group) ->
    @currentUser.fetchCurrent(success: (model) =>
      showView = new RippleApp.Views.GroupShow(model: group, user: model)
      RippleApp.layout.setMainView(showView)
    )