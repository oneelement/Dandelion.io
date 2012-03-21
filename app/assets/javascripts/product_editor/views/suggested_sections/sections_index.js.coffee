class ProductEditor.Views.SuggestedSectionsIndex extends Backbone.View

  template: JST['product_editor/suggested_sections/index']

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#suggested-sections').fadeOut(50))
    @collection.bind("reset", -> $('#suggested-sections').fadeIn(200))

  render: ->
    sections_to_display = @collection.notAlreadyAddedToSelected()

    $(@el).html(@template(
      sections: @collection.toJSON()
      sections_to_display: sections_to_display
    ))

    if @collection.length > 0
      $('#suggested-sections-list', @el).empty()
      _.each(
        sections_to_display
        (section) -> $('#suggested-sections-list', @el).append(
          new ProductEditor.Views.SuggestedSectionsShow(model: section).render().el)
        @)

    return @
