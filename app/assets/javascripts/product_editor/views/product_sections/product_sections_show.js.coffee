class ProductEditor.Views.ProductSectionsShow extends Backbone.View

  template: JST['product_editor/product_sections/show']
  tagName: 'li'
  className: 'product-section ui-button ui-widget ui-corner-all ui-button-text-icon-primary'

  initialize: ->
    @model.bind("change", @render, @)

  destroy: ->
    alert 'yo'

  render: ->
    if ProductEditor.app.get("selectedProductSection") == @model
      $(@el).removeClass('ui-state-default')
      $(@el).addClass('ui-state-focus')
    else
      $(@el).removeClass('ui-state-focus')
      $(@el).addClass('ui-state-default')

    $(@el).html(@template(@model.toJSON()))

    sub_sections = @model.get("product_sections")
    if sub_sections.length > 0
      $sub_el = $('.sub-sections', @el)
      $sub_el.append(new ProductEditor.Views.ProductSectionsIndex(
        collection: sub_sections
      ).render().el)

    return this

  events:
    "click": ->
      ProductEditor.app.selectProductSection @model
      #return false to prevent click propagation to parent sections
      return false
