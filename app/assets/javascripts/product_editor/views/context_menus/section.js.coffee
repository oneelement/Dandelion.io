class ProductEditor.Views.ContextMenuSection extends Backbone.View

  template: JST['product_editor/context_menus/section']

  events: ->
    "click #action-section-remove": -> ProductEditor.app.removeSection(@model)

  render: ->
    $(@el).html(@template())
    return @
