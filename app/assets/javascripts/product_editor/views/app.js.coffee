class ProductEditor.Views.AppView extends Backbone.View
  initialize: (app) ->

    @versionView = new ProductEditor.Views.ProductVersionsShow(
      model: @options.version
    )

    #Trigger a change to the sections involved in selection change, for redraw
    app.bind("change:selectedProductSection", (model, newSelection) ->

      prevSelection = app.previous("selectedProductSection")
      if prevSelection?
        prevSelection.trigger("change")

      if newSelection?
        newSelection.trigger("change")
    )

    @selectedSectionView = new ProductEditor.Views.SelectedSection()
    @suggestedSectionsView = new ProductEditor.Views.SuggestedSectionsIndex(
      collection: app.suggestedSections
    )
    @suggestedQuestionsView = new ProductEditor.Views.SuggestedQuestionsIndex(
      collection: app.suggestedQuestions
    )

    $('#action-save').click ->
      app.save()

  render: ->
    $('#section-tree').html(@versionView.render().el)
    $('#section-detail').html(@selectedSectionView.render().el)

    $('#sections', '#suggestions').html(@suggestedSectionsView.render().el)
    $('#questions', '#suggestions').html(@suggestedQuestionsView.render().el)
