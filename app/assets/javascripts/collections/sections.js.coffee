class Onelement.Collections.Sections extends Backbone.Collection
    url: '/sections'
    model: Onelement.Models.Section
    fetchTopLevel: ->
        @fetch(
            data: 
                topLevel: true)

