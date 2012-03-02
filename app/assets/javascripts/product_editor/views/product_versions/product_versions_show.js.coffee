class ProductEditor.Views.ProductVersionsShow extends Backbone.View

  template: JST['product_editor/product_versions/show']

  initialize: ->
    @model.bind("change", @render, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))

    product_sections = @model.get("product_sections")
    if product_sections.length > 0
      $sub_el = $('#product-sections', @el).empty()
      $sub_el.append(new ProductEditor.Views.ProductSectionsIndex(
        collection: product_sections
      ).render().el)

    return this
