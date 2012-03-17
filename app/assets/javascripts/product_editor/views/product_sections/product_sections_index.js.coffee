class ProductEditor.Views.ProductSectionsIndex extends Backbone.View

  tagName: 'ul'
  render: ->
    $(@el).empty()
    _.each(
      @collection.models
      (product_section) ->
        if not product_section.get("_destroy")
          $(@el).append(new ProductEditor.Views.ProductSectionsShow(
            model: product_section
            collection: @collection
          ).render().el)
      @)

    return @
