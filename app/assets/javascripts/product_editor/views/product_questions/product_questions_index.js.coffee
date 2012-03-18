class ProductEditor.Views.ProductQuestionsIndex extends Backbone.View

  template: JST['product_editor/product_questions/index']

  initialize: ->
    @collection.bind("add remove change", @render, @)
    @subViews = []

  remove: ->
    @collection.unbind("add remove change", @render, @)
    super()

  render: ->
    $(@el).html(@template({hasVisible: @collection.hasVisible()}))

    _.each(@subViews, (view) ->
      view.remove())

    @subViews = []

    $sub = $('#product-questions', @el)
    if $sub?
      $sub.empty()

      _.each(@collection.visibleModels(), (product_question) ->
          @subViews.push(new ProductEditor.Views.ProductQuestionsShow(
            model: product_question
          ).render())
        @)

      _.each(@subViews, (view) ->
        $sub.append(view.el))

    return @
