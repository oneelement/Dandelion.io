class ClientEditor.Views.ContactsShow extends Backbone.View

  template: JST['client_editor/client_show']

  tagName: 'li'

  render: ->
    $(@el).html(@template(client: @model))
    return this

  initialize: ->
    @model.on('change', @render, this)
