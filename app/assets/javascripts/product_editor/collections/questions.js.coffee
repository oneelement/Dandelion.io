class ProductEditor.Collections.Questions extends Backbone.Collection
  url: '/questions'
  model: ProductEditor.Models.Question
  fetchSuggestions: (id) ->
    @fetch(
      data:
        suggestions: true
        section_id: id)

  fetchCustom: (id) ->
    @fetch(
      data:
        custom: true
        section_id: id)

  notAlreadyAddedToSelected: ->
    #Return a list of questions which haven't already been added to the selected section.
    selectedSection = ProductEditor.app.get("selectedProductSection")

    if selectedSection?
      child_question_ids = _.map(selectedSection.get("product_questions").models, (product_question) ->
        if not product_question.get("_destroy")
          return product_question.get("question").id
      )

      return _.filter(@models, (model) ->
        return (not _.include(child_question_ids, model.id))
      )

    return []
