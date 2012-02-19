class Onelement.Routers.ProductVersions extends Backbone.Router
    routes:
        "": "root"

    root: ->
        @version = new Onelement.Models.ProductVersion(
            id: $('#version-id').text()
            productId: $('#product-id').text()
        )
        @versionView = new Onelement.Views.ProductVersionsShow(model: @version)
        $('#editor').html(@versionView.render().el)
        @version.fetch()

        @suggestedSections = new Onelement.Collections.Sections()
        @suggestedSectionsView = new Onelement.Views.SectionsIndex(
            version: @version
            collection: @suggestedSections
        )
        $('#sections').html(@suggestedSectionsView.render().el)
        @suggestedSections.fetchTopLevel()
