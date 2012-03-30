class ProductEditor.Views.ProductSectionsIndex extends Backbone.View

  initialize: ->
    @subViews = []

  tagName: 'ul'
  className: 'nav nav-stacked nav-tabs'

  render: ->

    #Tidy up existing views
    _.each(@subViews, (view) ->
      view.remove())

    @subViews = []

    _.each(@collection.visibleModels(), (product_section) ->
        @subViews.push(new ProductEditor.Views.ProductSectionsShow(
          model: product_section
        ).render())
      @)

    _.each(@subViews, (view) ->
        $(@el).append(view.el)
      @)


    return @
