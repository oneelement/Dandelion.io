class ProductEditor.Views.SuggestedSectionsIndex extends Backbone.View

  template: JST['product_editor/suggested_sections/index']
  render: ->
    $(@el).html(@template({sections: @collection.toJSON()}))

    if @collection.length > 0
      $('#suggested-child-sections', @el).empty()
      _.each(
        @collection.models
        (section) -> $('#suggested-child-sections', @el).append(
          new ProductEditor.Views.SuggestedSectionsShow(model: section).render().el)
        @)

    return @

  initialize: ->
    @collection.bind("reset", @render, @)
