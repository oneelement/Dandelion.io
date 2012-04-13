class ContactManager.Views.ContactNew extends Backbone.View
  template: JST['contact_manager/contact_new']
  
  events:
    'click #submit-contact': 'createContact'
    
  initialize: ->
    @collection = new ContactManager.Collections.Contacts()
  
  render: ->
    $(@el).html(@template)
    return this
    
  createContact: (event) ->
    event.preventDefault()
    attributes = name: $('#new_contact_name').val()
    @collection.create attributes,
      wait: true
      success: @handleSuccess
      
  handleSuccess: (contact, response) ->
    #console.log(response._id)
    redirect = response._id
    #Backbone.history.navigate("/#show/" + redirect, true)
    window.location = "/contacts/#show/" + redirect
    
    