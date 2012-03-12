class ProductEditor.Views.ProductSectionsIndex extends Backbone.View

  tagName: 'ul'
  render: ->
    $(@el).empty()
    _.each(
      @collection.models
      (product_section) ->
        $(@el).append(new ProductEditor.Views.ProductSectionsShow(
          model: product_section
          collection: @collection
        ).render().el)
      @)

    return @
