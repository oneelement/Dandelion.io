class Onelement.Views.ProductVersionsShow extends Backbone.View

  template: JST['product_versions/show']
  render: ->
    $(@el).html(@template(@model.toJSON()))

    product_sections = @model.get("product_sections")
    if product_sections.length > 0
      $sub_el = $('#product-sections', @el).empty()
      $sub_el.append(new Onelement.Views.ProductSectionsIndex(
        collection: product_sections
        version: @model
      ).render().el)

    selectedSection = @model.get("selectedSection")
    if selectedSection?
      current_section_questions = selectedSection.get("product_questions")
      if current_section_questions.length > 0
        $sub_el = $('#section-questions', @el).empty()
        $sub_el.append(new Onelement.Views.ProductQuestionsIndex(
          collection: current_section_questions
          version: @model
        ).render().el)

    return this

  initialize: -> @model.bind("change", @render, this)
