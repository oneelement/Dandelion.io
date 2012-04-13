class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "contacts": "index"
    "contacts/show/:id": "edit"
    "contacts/new": "newContact"

  initialize: ->
    @collection = new RippleApp.Collections.Contacts()
    @recentContacts = new RippleApp.Collections.Contacts()
    @view = new RippleApp.Views.ContactsIndex(collection: @collection)
    return @

  index: ->
    console.log('at contacts index')
    RippleApp.layout.setMainView(@view)
    @collection.fetch()
  
  newContact: ->
    view = new RippleApp.Views.ContactNew()
    $('#contact-modal', @el).html(view.render().el)
  
  edit: (id) ->
    @currentContact = new RippleApp.Models.Contact({_id: id})
    view = new RippleApp.Views.Contact(model: @currentContact)
    RippleApp.layout.setContextView(view)

    showView = new RippleApp.Views.ContactsShow(model: @currentContact)
    RippleApp.layout.setMainView(showView)

    recent = @recentContacts
    @currentContact.fetch(success: (model) ->
      recent.add(model)
      recent.trigger("add")
    )
