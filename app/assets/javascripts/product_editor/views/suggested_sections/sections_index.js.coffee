class ProductEditor.Views.SuggestedSectionsIndex extends Backbone.View

  template: JST['product_editor/suggested_sections/index']
  render: ->
    $(@el).html(@template({sections: @collection.toJSON()}))

    if @collection.length > 0
      $('#suggested-sections-list', @el).empty()
      _.each(
        @collection.models
        (section) -> $('#suggested-sections-list', @el).append(
          new ProductEditor.Views.SuggestedSectionsShow(model: section).render().el)
        @)

    return @

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#suggested-sections').fadeOut(50))
    @collection.bind("reset", -> $('#suggested-sections').fadeIn(200))
