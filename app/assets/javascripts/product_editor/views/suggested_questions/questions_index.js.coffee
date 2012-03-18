class ProductEditor.Views.SuggestedQuestionsIndex extends Backbone.View

  template: JST['product_editor/suggested_questions/index']
  render: ->
    $(@el).html(@template({questions: @collection.toJSON()}))

    if @collection.length > 0
      $('#suggested-questions-list', @el).empty()
      _.each(
        @collection.models
        (question) -> $('#suggested-questions-list', @el).append(
          new ProductEditor.Views.SuggestedQuestionsShow(model: question).render().el)
        @)

    return @

  initialize: ->
    @collection.bind("reset", @render, @)
    @collection.bind("reset", -> $('#suggested-questions').fadeIn(200))
