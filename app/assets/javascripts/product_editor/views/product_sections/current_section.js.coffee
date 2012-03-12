class ProductEditor.Views.CurrentSection extends Backbone.View

  template: JST['product_editor/current_section']

  render: ->
    $(@el).html(@template(@model.toJSON()))

    model = @model
    $('#section-attribute-repeats', @el).bind("change", (event) ->
        model.set("repeats", event.target.checked))

    return this
