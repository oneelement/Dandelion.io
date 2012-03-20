class ProductEditor.Views.NewCustomSectionDialog extends Backbone.View

  template: JST['product_editor/dialogs/new_custom_section']

  id: "new-custom-section-dialog"

  attributes:
    title: "Create a new section"

  render: ->
    selectedProductSection = ProductEditor.app.get("selectedProductSection")

    selectedSectionJSON = null
    if selectedProductSection?
      selectedSectionJSON = selectedProductSection.get("section").toJSON()

    $(@el).html(@template(
      selectedSection: selectedSectionJSON
    ))

    dialog = $(@el).dialog({
      modal: true
      height: "auto"
      width: "50%"
    })

    $('#add-new-custom-section', @el).button(
      icons:
        primary: 'ui-icon-plusthick'
    )
    $('#new-section-details-form', @el).submit( (event) ->
      event.preventDefault()

      name = $.trim($('#new-section-name', @el).val())
      if name != ''
        ProductEditor.app.addCustomSection(
          name: name
        )
        dialog.dialog("close")
      else
        $('#new-section-error-message', @el).html('Please enter a name for the section.')
    )
