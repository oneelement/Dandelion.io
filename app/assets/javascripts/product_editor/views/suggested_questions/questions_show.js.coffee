class ProductEditor.Views.SuggestedQuestionsShow extends Backbone.View

  template: JST['product_editor/suggested_questions/show']
  tagName: 'li'
  className: 'product-question ui-button ui-widget ui-state-default ui-corner-all ui-button-text-icon-primary'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  events: "click": ->
    ProductEditor.app.addQuestion(@model)
