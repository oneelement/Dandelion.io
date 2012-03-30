class ProductEditor.Views.CustomQuestionsShow extends Backbone.View

  template: JST['product_editor/custom_questions/show']
  tagName: 'li'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  events: "click": ->
    ProductEditor.app.addQuestion(@model)
