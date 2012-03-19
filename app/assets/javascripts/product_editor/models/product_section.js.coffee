class ProductEditor.Models.ProductSection extends Backbone.RelationalModel
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
      details = s.get("builder_details_container")
      if details?
        @set("repeats", details.repeats)
        if details.repeats?
          @set("repeat_max_instances", details.repeat_max_instances)

  addSection: (product_section) ->
    @get("product_sections").add(product_section)

  addQuestion: (question) ->
    q = new ProductEditor.Models.ProductQuestion(question: question)
    @get("product_questions").add(q)
