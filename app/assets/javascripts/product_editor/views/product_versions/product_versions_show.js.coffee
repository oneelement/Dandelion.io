class ProductEditor.Views.ProductVersionsShow extends Backbone.View

  template: JST['product_editor/product_versions/show']

  initialize: ->
    @model.bind("change", @render, @)

    product_sections = @model.get("product_sections")

    product_sections.bind("change", @render, @)
    @productSectionsView = new ProductEditor.Views.ProductSectionsIndex(
      collection: product_sections
    )

  render: ->
    $(@el).html(@template({hasVisible: @model.get("product_sections").hasVisible()}))

    if @model.get("product_sections").hasVisible()
      $sub_el = $('#product-sections', @el).empty()
      $sub_el.append(@productSectionsView.render().el)

    return this
