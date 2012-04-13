class ContactManager.Routers.Contacts extends Backbone.Router
  routes:
    "": "index"
    "show/:id": "edit"
    "new": "newContact"

  initialize: ->
    @collection = new ContactManager.Collections.Contacts()
    @contactsTree = new ContactManager.Collections.ContactsTree()
    @collection.fetch()
    @view = new ContactManager.Views.ContactsIndex(collection: @collection, treeCollection: @contactsTree)
    return @

  index: ->
    $('#contacts-container').html(@view.render().el)
  
  newContact: ->
    view = new ContactManager.Views.ContactNew
    $('#contact-modal').html(view.render().el)
  
  edit: (id) ->
    console.log('edit, ' + id)
    @currentContact = new ContactManager.Models.Contact({_id: id})
    view = new ContactManager.Views.Contact(model: @currentContact)
    $('#contact-container').html(view.render().el)

    tree = @contactsTree
    @currentContact.fetch(success: (model) ->
      tree.add(model)
      tree.trigger("add")
    )
