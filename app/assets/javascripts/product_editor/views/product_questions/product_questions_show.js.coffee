class ProductEditor.Views.ProductQuestionsShow extends Backbone.View

  template: JST['product_editor/product_questions/show']
  tagName: 'li'
  className: 'product-question ui-button ui-widget ui-corner-all ui-button-text-icon-primary'

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return @
