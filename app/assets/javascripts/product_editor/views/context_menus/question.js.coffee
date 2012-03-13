class ProductEditor.Views.ContextMenuQuestion extends Backbone.View

  tagName: 'ul'

  template: JST['product_editor/context_menus/question']

  events: ->
    "click #action-question-remove": -> ProductEditor.app.removeQuestion(@model)

  render: ->
    $(@el).html(@template())
    return @
