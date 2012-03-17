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

    app.bind("change:selectedProductSection", (model, newSelection) ->
      $questions = $('#questions')
      $questions.fadeOut(50, ->
        $questions.empty()
        if newSelection?
          $questions.html(new ProductEditor.Views.ProductQuestionsIndex(
            collection: newSelection.get("product_questions")
          ).render().el)
        $questions.fadeIn(500))
    )

    app.bind("change:selectedProductSection", (model, newSelection) ->
      $current = $('#current-section')
      $current.fadeOut(50, ->
        $current.empty()
        if newSelection?
          $current.html(new ProductEditor.Views.CurrentSection(
            model: newSelection
          ).render().el)
        $current.fadeIn(500))
    )

    app.bind("change:selectedProductQuestion", (model, newSelection) ->
      $current = $('#current-question')
      $current.fadeOut(50, ->
        $current.empty()
        if newSelection?
          $current.html(new ProductEditor.Views.CurrentQuestion(
            model: newSelection
          ).render().el)
        $current.fadeIn(500))
    )

    app.bind("change:selectedProductSection", ->
      $('#suggested-sections').fadeOut(50)
      $('#suggested-questions').fadeOut(50)
    )

  render: ->
    $('#sections').html(@versionView.render().el)
    $('#suggested-sections').html(@suggestedSectionsView.render().el)
    $('#suggested-questions').html(@suggestedQuestionsView.render().el)

    return @
