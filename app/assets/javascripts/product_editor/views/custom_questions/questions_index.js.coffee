class ProductEditor.Views.CustomQuestionsIndex extends Backbone.View

  template: JST['product_editor/custom_questions/index']

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#custom-questions').fadeOut(50))
    @collection.bind("reset", -> $('#custom-questions').fadeIn(400))
    @dialog = new ProductEditor.Views.NewCustomQuestionDialog()

  render: ->
    questions_to_display = @collection.notAlreadyAddedToSelected()

    $(@el).html(@template(
      questions: @collection.toJSON()
      questions_to_display: questions_to_display
    ))

    $('#new-custom-question').button()

    if @collection.length > 0
      $('#custom-questions-list', @el).empty()
      _.each(
        questions_to_display
        (question) -> $('#custom-questions-list', @el).append(
          new ProductEditor.Views.CustomQuestionsShow(model: question).render().el)
        @)

    return @

  events:
    "click #new-custom-question": "showNewCustomQuestionDialog"

  showNewCustomQuestionDialog: ->
    @dialog.render()
