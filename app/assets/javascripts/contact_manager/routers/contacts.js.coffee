class RippleApp.Routers.Contacts extends Backbone.Router
  routes:
    "": "index"
    "contacts": "indexContact"
    "contacts/show/:id": "edit"
    "contacts/new": "newContact"

  initialize: ->
    @collection = new RippleApp.Collections.Contacts()
    @recentContacts = new RippleApp.Collections.Contacts()
    @view = new RippleApp.Views.ContactsIndex(collection: @collection)
    return @
    
  index: ->
    console.log('at main index')
    currentuser = new RippleApp.Models.Currentuser()
    currentuser.fetch(success: (currentuser, response) ->
      contact_id = response.contact_id
      @homeContact = new RippleApp.Models.Contact({_id: contact_id}) 
      @homeContact.fetch(success: (response) ->
        view = new RippleApp.Views.Contact(model: @homeContact)
        RippleApp.layout.setContextView(view)
      ) 
    )
    
    

  indexContact: ->
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
