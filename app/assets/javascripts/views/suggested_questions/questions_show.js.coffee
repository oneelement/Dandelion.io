class Onelement.Views.SuggestedQuestionsShow extends Backbone.View

  template: JST['suggested_questions/show']
  tagName: 'li'
  className: 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-icon-primary'
  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  initialize: -> @version = @options["version"]
  events:
    "click": -> @version.addQuestion(@model)
