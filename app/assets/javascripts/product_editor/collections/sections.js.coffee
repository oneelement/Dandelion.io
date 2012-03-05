class ProductEditor.Collections.Sections extends Backbone.Collection
    url: '/sections'
    model: ProductEditor.Models.Section
    fetchSuggestions: (id) ->
        @fetch(
            data:
                suggestions: true
                id: id)
