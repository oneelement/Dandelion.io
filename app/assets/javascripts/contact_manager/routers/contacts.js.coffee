class ContactManager.Routers.Contacts extends Backbone.Router
  routes:
    "": "index"
    "show/:id": "edit"
    "new": "newContact"

  initialize: ->
    @collection = new ContactManager.Collections.Contacts()
    @collection.fetch()
    return @

  index: ->
    view = new ContactManager.Views.ContactsIndex(collection: @collection)
    $('#contacts-container').html(view.render().el)
    
  
  newContact: ->
    view = new ContactManager.Views.ContactNew
    $('#contact-modal').html(view.render().el)
  
  
  edit: (id) ->
    #id = #{id}
    #@model = @collection.get('id')
    contact = new ContactManager.Models.Contact({_id: id})      
    #contact = @model.get('id')
    view = new ContactManager.Views.Contact(model: contact)
    $('#contact-container').html(view.render().el)
    #alert "#{id}"
    contact.fetch()
    
  

