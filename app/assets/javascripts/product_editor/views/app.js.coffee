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

    $('#action-save').click ->
      app.save()

    app.bind("change:selectedProductSection", (model, newSelection) ->
      $detail = $('#section-detail').empty()
      if newSelection?
        $detail.append(new ProductEditor.Views.CurrentSection(
          model: newSelection
        ).render().el)
    )

  render: ->
    $('#section-tree').html(@versionView.render().el)
    $('#sections', '#suggestions').html(@suggestedSectionsView.render().el)
    $('#questions', '#suggestions').html(@suggestedQuestionsView.render().el)

    return @
