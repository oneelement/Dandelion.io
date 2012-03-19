class ProductEditor.Views.CustomSectionsIndex extends Backbone.View

  template: JST['product_editor/custom_sections/index']

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#custom-sections').fadeOut(50))
    @collection.bind("reset", -> $('#custom-sections').fadeIn(400))

  render: ->
    $(@el).html(@template({sections: @collection.toJSON()}))

    if @collection.length > 0
      $('#custom-sections-list', @el).empty()
      _.each(
        @collection.models
        (section) -> $('#custom-sections-list', @el).append(
          new ProductEditor.Views.CustomSectionsShow(model: section).render().el)
        @)

    return @
