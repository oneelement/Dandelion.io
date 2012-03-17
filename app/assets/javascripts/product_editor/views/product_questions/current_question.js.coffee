class ProductEditor.Views.CurrentQuestion extends Backbone.View

  id: "current-product-question"

  template: JST['product_editor/current_question']

  initialize: ->
    @model.bind("change", @render, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))

    model = @model

    $('#remove-selected-question', @el).button(
      icons:
        primary: 'ui-icon-circle-close')

    $('#remove-selected-question', @el).click(->
      ProductEditor.app.removeSelectedQuestion())

    return this
