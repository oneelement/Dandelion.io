class ProductEditor.Views.ProductSectionsShow extends Backbone.View

  template: JST['product_editor/product_sections/show']
  tagName: 'li'
  className: 'product-section ui-button ui-widget ui-corner-all ui-button-text-icon-primary'

  initialize: ->
    @model.bind("change", @render, @)

    product_sections = @model.get("product_sections")
    @subView = new ProductEditor.Views.ProductSectionsIndex(
      collection: product_sections
    )

  remove: ->
    @model.unbind("change", @render, @)
    super()


  render: ->
    if @model.get("_destroy")
      @remove()
    else
      if ProductEditor.app.get("selectedProductSection") == @model
        $(@el).removeClass('ui-state-default')
        $(@el).addClass('ui-state-focus')
      else
        $(@el).removeClass('ui-state-focus')
        $(@el).addClass('ui-state-default')

      $(@el).html(@template(@model.toJSON()))

      $sub_el = $('.sub-sections', @el).empty()

      sub_sections = @model.get("product_sections")
      if sub_sections.hasVisible()
        $sub_el.append(@subView.render().el)

    return @

  events:
    "click": ->
      ProductEditor.app.selectProductSection(@model)
      #return false to prevent click propagation to parent sections
      return false
