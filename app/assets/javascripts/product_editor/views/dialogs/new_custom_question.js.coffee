class ProductEditor.Views.NewCustomQuestionDialog extends Backbone.View

  template: JST['product_editor/dialogs/new_custom_question']

  id: "new-custom-question-dialog"

  attributes:
    title: "Create a new question"

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

    $('#add-new-custom-question', @el).button(
      icons:
        primary: 'ui-icon-plusthick'
    )
    $('#new-question-details-form', @el).submit( (event) ->
      event.preventDefault()

      name = $.trim($('#new-question-name', @el).val())
      type = $('#new-question-type', @el).val()
      if name != ''
        ProductEditor.app.addCustomQuestion(
          name: name
          type: type
        )
        dialog.dialog("close")
      else
        $('#new-question-error-message', @el).html('Please enter a name for the question.')
    )
