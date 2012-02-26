class Onelement.Views.ProductSectionsIndex extends Backbone.View

  tagName: 'ul'
  render: ->
    $(@el).empty()
    _.each(
      @collection.models
      (product_section) -> $(@el).append(new Onelement.Views.ProductSectionsShow(
        version: @version
        model: product_section).render().el)
      @)

    return @

  initialize: -> @version = @options["version"]
