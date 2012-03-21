class ProductEditor.Views.SuggestedSectionsShow extends Backbone.View

  template: JST['product_editor/suggested_sections/show']
  tagName: 'li'
  className: 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-icon-primary'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  events:
    "click": ->
      newProductSection = ProductEditor.app.addSection(@model)
      ProductEditor.app.selectProductSection(newProductSection)
