class Onelement.Collections.Sections extends Backbone.Collection
    url: '/sections'
    model: Onelement.Models.Section
    fetchSuggestions: (id) ->
        @fetch(
            data:
                suggestions: true
                id: id)
