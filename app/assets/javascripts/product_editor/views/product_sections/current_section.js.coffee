class ProductEditor.Views.CurrentSection extends Backbone.View

  template: JST['product_editor/current_section']

  initialize: ->
    @model.bind("change", @render, @)

  render: ->
    if @model?
      $(@el).html(@template(@model.toJSON()))

      questions = @model.get("product_questions")

      if questions.length > 0
        $sub_el = $('#questions-list', @el).empty()
        $sub_el.append(new ProductEditor.Views.ProductQuestionsIndex(
          collection: questions
        ).render().el)

    return this
