class ProductEditor.Models.ProductSection extends Backbone.RelationalModel
  idAttribute: '_id'
  relations: [
    {
      type: 'Backbone.HasOne'
      key: 'section'
      relatedModel: 'ProductEditor.Models.Section'
      includeInJSON: true
      createModels: true
    }, {
      type: 'HasMany'
      key: 'child_sections'
      relatedModel: 'ProductEditor.Models.ProductSection'
      collectionType: 'ProductEditor.Collections.ProductSections'
      includeInJSON: true
      createModels: true
    }, {
      type: 'HasMany'
      key: 'product_questions'
      relatedModel: 'ProductEditor.Models.ProductQuestion'
      collectionType: 'ProductEditor.Collections.ProductQuestions'
      includeInJSON: true
      createModels: true
    }
  ]

  initialize: ->
    @bind("add:child_sections remove:child_sections add:product_questions remove:product_questions", ->
        @trigger("change")
      @)

  addSection: (section) ->
    s = new ProductEditor.Models.ProductSection(section: section)
    @get("child_sections").add(s)

  addQuestion: (question) ->
    q = new ProductEditor.Models.ProductQuestion(question: question)
    @get("product_questions").add(q)
