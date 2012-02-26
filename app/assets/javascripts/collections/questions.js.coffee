class Onelement.Collections.Questions extends Backbone.Collection
    url: '/questions'
    model: Onelement.Models.Question
    fetchSuggestions: (id) ->
        @fetch(
            data:
                suggestions: true
                section_id: id)
