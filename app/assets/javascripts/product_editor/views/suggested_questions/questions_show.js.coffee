class ProductEditor.Views.SuggestedQuestionsShow extends Backbone.View

  template: JST['product_editor/suggested_questions/show']
  tagName: 'li'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  events: "click": ->
    ProductEditor.app.addQuestion(@model)
