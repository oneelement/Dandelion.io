class ProductEditor.Views.SelectedSection

  template: JST['product_editor/product_sections/show_selected']

  initialize: ->
    ProductEditor.state.bind("selectedProductSection", ->
      @model = ProductEditor.state.get("selectedProductSection")
      console.log(@)
      @render()
    @)

  render: ->
    if @model?

      questions = @model.get("product_questions")

      if questions.length > 0
        $sub_el = $('#questions-list', @el).empty()
        $sub_el.append(new ProductEditor.Views.ProductQuestionIndex(
          collection: questions
        ).render.el)

    return this
