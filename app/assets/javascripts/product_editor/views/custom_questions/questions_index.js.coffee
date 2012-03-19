class ProductEditor.Views.CustomQuestionsIndex extends Backbone.View

  template: JST['product_editor/custom_questions/index']

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#custom-questions').fadeOut(50))
    @collection.bind("reset", -> $('#custom-questions').fadeIn(400))

  render: ->
    $(@el).html(@template({questions: @collection.toJSON()}))

    if @collection.length > 0
      $('#custom-questions-list', @el).empty()
      _.each(
        @collection.models
        (question) -> $('#custom-questions-list', @el).append(
          new ProductEditor.Views.CustomQuestionsShow(model: question).render().el)
        @)

    return @
