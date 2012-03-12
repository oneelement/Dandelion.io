class ClientEditor.Views.ContactsIndex extends Backbone.View

  template: JST['client_editor/client_index']

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendEntry)
    this

  appendEntry: (client) =>
    view = new ClientEditor.Views.ContactsShow(model: client)
    $('#client_list').append(view.render().el)
