class Onelement.Views.SuggestedQuestionsIndex extends Backbone.View

  template: JST['suggested_questions/index']
  render: ->
    $(@el).html(@template({questions: @collection.toJSON()}))

    if @collection.length > 0
      $('#suggested-questions', @el).empty()
      _.each(
        @collection.models
        (question) -> $('#suggested-questions', @el).append(
          new Onelement.Views.SuggestedQuestionsShow(model: question, version: @version).render().el)
        @)

    return @

  initialize: ->
    @collection.bind("reset", @render, this)
    @version = @options["version"]
