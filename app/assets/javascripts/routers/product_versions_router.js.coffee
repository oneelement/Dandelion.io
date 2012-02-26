class Onelement.Routers.ProductVersions extends Backbone.Router
  routes:
    "": "root"
    "sections/:id": "suggestions"

  initialize: ->
    @version = new Onelement.Models.ProductVersion(
      id: $('#version-id').text()
      productId: $('#product-id').text()
    )
    @versionView = new Onelement.Views.ProductVersionsShow(model: @version)
    $('#editor').html(@versionView.render().el)
    @version.fetch()

    @suggestedSections = new Onelement.Collections.Sections()
    @suggestedSectionsView = new Onelement.Views.SuggestedSectionsIndex(
      version: @version
      collection: @suggestedSections
    )
    $('#sections').html(@suggestedSectionsView.render().el)

    @suggestedQuestions = new Onelement.Collections.Questions()
    @suggestedQuestionsView = new Onelement.Views.SuggestedQuestionsIndex(
      version: @version
      collection: @suggestedQuestions
    )
    $('#questions').html(@suggestedQuestionsView.render().el)


  root: ->
    @suggestedSections.fetchSuggestions()
    @suggestedQuestions.fetchSuggestions()

  suggestions: (id) ->
    @suggestedSections.fetchSuggestions(id)
    @suggestedQuestions.fetchSuggestions(id)
