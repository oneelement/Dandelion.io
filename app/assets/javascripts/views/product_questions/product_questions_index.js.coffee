class Onelement.Views.ProductQuestionsIndex extends Backbone.View

  tagName: 'ul'
  render: ->
    $(@el).empty()
    _.each(
      @collection.models
      (product_question) -> $(@el).append(new Onelement.Views.ProductQuestionsShow(
        version: @version
        model: product_question).render().el)
      @)

    return @

  initialize: -> @version = @options["version"]
