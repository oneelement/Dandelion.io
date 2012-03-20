class ProductEditor.Views.CustomSectionsIndex extends Backbone.View

  template: JST['product_editor/custom_sections/index']

  initialize: ->
    @collection.bind("reset", @render, @)
    ProductEditor.app.bind("change:selectedProductSection", -> $('#custom-sections').fadeOut(50))
    @collection.bind("reset", -> $('#custom-sections').fadeIn(400))
    @dialog = new ProductEditor.Views.NewCustomSectionDialog()

  render: ->
    sections_to_display = @collection.notAlreadyAddedToSelected()

    $(@el).html(@template(
      sections: @collection.toJSON()
      sections_to_display: sections_to_display
    ))

    $('#new-custom-section').button(
      icons:
        primary: 'ui-icon-plusthick'
    )

    if @collection.length > 0
      $('#custom-sections-list', @el).empty()
      _.each(
        sections_to_display
        (section) -> $('#custom-sections-list', @el).append(
          new ProductEditor.Views.CustomSectionsShow(model: section).render().el)
        @)

    return @

  events:
    "click #new-custom-section": "showNewCustomSectionDialog"

  showNewCustomSectionDialog: ->
    @dialog.render()
