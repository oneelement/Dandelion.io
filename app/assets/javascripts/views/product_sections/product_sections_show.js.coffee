class Onelement.Views.ProductSectionsShow extends Backbone.View

  template: JST['product_sections/show']
  tagName: 'li'
  className: 'product-section ui-button ui-widget ui-corner-all ui-button-text-icon-primary'

  render: ->
    if @model.get("selected")
      $(@el).addClass('ui-state-focus')
    else
      $(@el).addClass('ui-state-default')

    $(@el).html(@template(@model.toJSON()))

    sub_sections = @model.get("product_sections")
    if sub_sections.length > 0
      $sub_el = $('.sub-sections', @el)
      $sub_el.append(new Onelement.Views.ProductSectionsIndex(
        collection: sub_sections
        version: @version
      ).render().el)

    return this

  initialize: ->
    @version = @options["version"]

  events:
    "click": -> @version.selectSection(@model)
