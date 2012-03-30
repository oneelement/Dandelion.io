class ProductEditor.Views.SuggestedSectionsShow extends Backbone.View

  template: JST['product_editor/suggested_sections/show']
  tagName: 'li'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  events:
    "click": ->
      newProductSection = ProductEditor.app.addSection(@model)
      ProductEditor.app.selectProductSection(newProductSection)
