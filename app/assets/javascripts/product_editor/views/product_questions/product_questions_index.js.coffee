class ProductEditor.Views.ProductQuestionsIndex extends Backbone.View

  tagName: 'ul'
  render: ->
    $(@el).empty()
    _.each(
      @collection.models
      (product_question) -> $(@el).append(new ProductEditor.Views.ProductQuestionsShow(
        model: product_question).render().el)
      @)

    return @
