class ProductEditor.Views.ProductQuestionsIndex extends Backbone.View

  template: JST['product_editor/product_questions/index']

  initialize: ->
    @collection.bind("add remove change", @render, @)

  render: ->
    $(@el).html(@template({hasVisible: @collection.hasVisible()}))

    $sub = $('#product-questions', @el)
    if $sub?
      $sub.empty()

      _.each(
        @collection.visibleModels()
        (product_question) ->
          $sub.append(new ProductEditor.Views.ProductQuestionsShow(
            model: product_question).render().el)
        @)

    return @
