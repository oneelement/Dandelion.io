class ProductEditor.Models.ProductVersion extends Backbone.RelationalModel
  urlRoot: -> '/products/' + @get('product_id') + '/versions'
  relations: [
    {
      type: 'HasMany'
      key: 'product_sections'
      relatedModel: 'ProductEditor.Models.ProductSection'
      collectionType: 'ProductEditor.Collections.ProductSections'
      includeInJSON: true
      createModels: true
    },{
      type: 'HasOne'
      key: 'selectedSection'
      relatedModel: 'ProductEditor.Models.ProductSection'
      includeInJSON: true
      createModels: true
    }
  ]

  initialize: ->
    @bind("add:product_sections remove:product_sections", ->
        @trigger("change")
      @)

  addSection: (product_section) ->
    @get("product_sections").add(product_section)

  addQuestion: (question) ->
    q = new ProductEditor.Models.ProductQuestion(question: question)
    currentSection.get("product_questions").add(q)
