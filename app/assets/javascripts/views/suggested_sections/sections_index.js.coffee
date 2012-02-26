class Onelement.Views.SuggestedSectionsIndex extends Backbone.View

  template: JST['suggested_sections/index']
  render: ->
    $(@el).html(@template({sections: @collection.toJSON()}))

    if @collection.length > 0
      $('#suggested-child-sections', @el).empty()
      _.each(
        @collection.models
        (section) -> $('#suggested-child-sections', @el).append(
          new Onelement.Views.SuggestedSectionsShow(model: section, version: @version).render().el)
        @)

    return @

  initialize: ->
    @collection.bind("reset", @render, this)
    @version = @options["version"]
