class Onelement.Views.SectionsIndex extends Backbone.View

  tagName: 'ul'
  render: ->
    $(@el).empty()
    _.each(
      @collection.models
      (section) -> $(@el).append(new Onelement.Views.SectionsShow(model: section, version: @version).render().el)
      this)
    return this

  initialize: ->
    @collection.bind("reset", @render, this)
    @version = @options["version"]
