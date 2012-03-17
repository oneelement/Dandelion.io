class ProductEditor.Views.ProductQuestionsShow extends Backbone.View

  template: JST['product_editor/product_questions/show']
  tagName: 'li'
  className: 'product-question ui-button ui-widget ui-corner-all ui-button-text-icon-primary ui-state-default'

  initialize: ->
    @model.bind("change", @render, @)

  render: ->
    if @model.get("_destroy")
      @remove()
    else
      if ProductEditor.app.get("selectedProductQuestion") == @model
        $(@el).removeClass('ui-state-default')
        $(@el).addClass('ui-state-focus')
      else
        $(@el).removeClass('ui-state-focus')
        $(@el).addClass('ui-state-default')

      $(@el).html(@template(@model.toJSON()))

    return @

  events:
    "click": ->
      ProductEditor.app.selectProductQuestion(@model)
      return false
