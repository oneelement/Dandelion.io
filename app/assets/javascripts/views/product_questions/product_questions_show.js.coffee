class Onelement.Views.ProductQuestionsShow extends Backbone.View

  template: JST['product_questions/show']
  tagName: 'li'
  className: 'product-question ui-button ui-widget ui-corner-all ui-button-text-icon-primary'

  render: ->
    $(@el).html(@template(@model.toJSON()))

    return this

  initialize: ->
    @version = @options["version"]

  events:
    "click": -> @version.selectQuestion(@model)
