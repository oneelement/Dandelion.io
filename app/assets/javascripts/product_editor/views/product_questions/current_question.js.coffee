class ProductEditor.Views.CurrentQuestion extends Backbone.View

  id: "current-product-question"

  template: JST['product_editor/current_question']

  initialize: ->
    @model.bind("change", @render, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))

    model = @model

    return this
