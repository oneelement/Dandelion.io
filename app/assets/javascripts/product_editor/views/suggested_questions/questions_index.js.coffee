class ProductEditor.Views.SuggestedQuestionsIndex extends Backbone.View

  template: JST['product_editor/suggested_questions/index']

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#suggested-questions').fadeOut(50))
    @collection.bind("reset", -> $('#suggested-questions').fadeIn(200))

  render: ->
    questions_to_display = @collection.notAlreadyAddedToSelected()

    $(@el).html(@template(
      questions: @collection.toJSON()
      questions_to_display: questions_to_display
    ))

    if @collection.length > 0
      $('#suggested-questions-list', @el).empty()
      _.each(
        @collection.notAlreadyAddedToSelected()
        (question) -> $('#suggested-questions-list', @el).append(
          new ProductEditor.Views.SuggestedQuestionsShow(model: question).render().el)
        @)

    return @
