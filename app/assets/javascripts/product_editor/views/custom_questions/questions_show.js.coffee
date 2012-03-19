class ProductEditor.Views.CustomQuestionsShow extends Backbone.View

  template: JST['product_editor/custom_questions/show']
  tagName: 'li'
  className: 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-icon-primary'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  events: "click": ->
    ProductEditor.app.addQuestion(@model)
