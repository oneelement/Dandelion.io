class ClientEditor.Routers.Contacts extends Backbone.Router
  routes:
    '': "index"
    "contact/:id": "edit"
    "new": "newClient"

  initialize: ->
    @collection = new ClientEditor.Collections.Contacts()
    @collection.fetch()
    return @

  index: ->
    view = new ClientEditor.Views.ContactsIndex(collection: @collection)
    $('#app').html(view.render().el)

