class ProductEditor.Collections.Questions extends Backbone.Collection
    url: '/questions'
    model: ProductEditor.Models.Question
    fetchSuggestions: (id) ->
        @fetch(
            data:
                suggestions: true
                section_id: id)
