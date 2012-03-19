class ProductEditor.Views.AppView extends Backbone.View
  initialize: (app) ->

    @versionView = new ProductEditor.Views.ProductVersionsShow(
      model: app.version
    )

    @suggestedSectionsView = new ProductEditor.Views.SuggestedSectionsIndex(
      collection: app.suggestedSections
    )
    @suggestedQuestionsView = new ProductEditor.Views.SuggestedQuestionsIndex(
      collection: app.suggestedQuestions
    )
    @customSectionsView = new ProductEditor.Views.CustomSectionsIndex(
      collection: app.customSections
    )
    @customQuestionsView = new ProductEditor.Views.CustomQuestionsIndex(
      collection: app.customQuestions
    )

    saveButton = $('#action-save').button(
      icons:
        primary: 'ui-icon-disk')

    saveButton.click ->
      saveButton.button("option",
        icons:
          primary: 'ui-icon-disk'
          secondary: 'ui-icon-transfer-e-w')
      app.save()

    app.version.bind("sync", ->
      saveButton.button("option",
        icons:
          primary: 'ui-icon-disk')

      $('#notice-content').html('Saved successfully')
      $('#notice').slideDown().delay(2000).slideUp()
    )

    productQuestionsView = @productQuestionsView = null
    app.bind("change:selectedProductSection", (model, newSelection) ->
      $questions = $('#questions')
      $questions.fadeOut(50, ->

        $questions.empty()
        if productQuestionsView?
          productQuestionsView.remove()

        if newSelection?
          productQuestionsView = new ProductEditor.Views.ProductQuestionsIndex(
            collection: newSelection.get("product_questions")
          ).render()

          $questions.html(productQuestionsView.el)

        $questions.fadeIn(200))
    )

    currentSectionView = @currentSectionView = null
    app.bind("change:selectedProductSection", (model, newSelection) ->
      $current = $('#current-section')
      $current.fadeOut(50, ->

        $current.empty()
        if currentSectionView?
          currentSectionView.remove()

        if newSelection?
          currentSectionView = new ProductEditor.Views.CurrentSection(
            model: newSelection
          ).render()

          $current.html(currentSectionView.el)

        $current.fadeIn(200))
    )

    currentQuestionView = @currentQuestionView = null
    app.bind("change:selectedProductQuestion", (model, newSelection) ->
      $current = $('#current-question')
      $current.fadeOut(50, ->

        $current.empty()
        if currentQuestionView?
          currentQuestionView.remove()

        if newSelection?
          currentQuestionView = new ProductEditor.Views.CurrentQuestion(
            model: newSelection
          ).render()

          $current.html(currentQuestionView.el)

        $current.fadeIn(200))
    )

  render: ->
    $('#sections').html(@versionView.render().el)
    $('#suggested-sections').html(@suggestedSectionsView.render().el)
    $('#suggested-questions').html(@suggestedQuestionsView.render().el)
    $('#custom-sections').html(@customSectionsView.render().el)
    $('#custom-questions').html(@customQuestionsView.render().el)

    return @
