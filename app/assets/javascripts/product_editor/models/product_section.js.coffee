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
      key: 'product_sections'
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
    @bind("add:product_sections remove:product_sections add:product_questions remove:product_questions", ->
        @trigger("change")
      @)

  loadDefaults: ->
    s = @get("section")

    if s?
      metadata = s.get("builder_metadata")
      if metadata?
        @set("repeats", metadata.repeats)
        if metadata.repeats?
          @set("repeat_max_instances", metadata.repeat_max_instances)

  addSection: (section) ->
    s = new ProductEditor.Models.ProductSection(section: section)
    s.loadDefaults()
    @get("product_sections").add(s)

  addQuestion: (question) ->
    q = new ProductEditor.Models.ProductQuestion(question: question)
    @get("product_questions").add(q)
