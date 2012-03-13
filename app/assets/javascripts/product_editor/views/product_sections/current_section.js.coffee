class ProductEditor.Views.CurrentSection extends Backbone.View

  id: "current-product-section"

  template: JST['product_editor/current_section']

  initialize: ->
    @model.bind("change", @render, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))

    model = @model

    $('#section-attribute-mandatory', @el).bind("change", (event) ->
      model.set("mandatory", event.target.checked))

    $('#section-attribute-repeats', @el).bind("change", (event) ->
      model.set("repeats", event.target.checked))

    $('#section-attribute-repeat-max-instances', @el).bind("change", (event) ->
      model.set("repeat_max_instances", event.target.value))

    return this
