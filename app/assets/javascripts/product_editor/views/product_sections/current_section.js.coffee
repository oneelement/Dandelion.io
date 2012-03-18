class ProductEditor.Views.CurrentSection extends Backbone.View

  id: "current-product-section"

  template: JST['product_editor/current_section']

  initialize: ->
    @model.bind("change", @render, @)

  remove: ->
    @model.unbind("change", @render, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))

    model = @model

    $('#section-attribute-mandatory', @el).button(
      icons:
        primary: 'ui-icon-bullet'
        secondary: if @model.get("mandatory") then 'ui-icon-check')

    $('#section-attribute-repeats', @el).button(
      icons:
        primary: 'ui-icon-refresh'
        secondary: if @model.get("repeats") then 'ui-icon-check')

    $('#remove-selected-section', @el).button(
      icons:
        primary: 'ui-icon-circle-close')

    $('#section-attribute-mandatory', @el).bind("change", (event) ->
      model.set("mandatory", event.target.checked))

    $('#section-attribute-repeats', @el).bind("change", (event) ->
      model.set("repeats", event.target.checked))

    $('#section-attribute-repeat-max-instances', @el).bind("change", (event) ->
      model.set("repeat_max_instances", event.target.value))

    $('#section-attribute-repeat-max-instances', @el).click((event) ->
      #Prevent selecting the text box to toggle the underlying checkbox
      return false
    )

    $('#remove-selected-section', @el).click ->
      ProductEditor.app.removeSelectedSection()

    return @
