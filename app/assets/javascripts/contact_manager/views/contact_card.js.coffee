class RippleApp.Views.ContactCard extends Backbone.View
  template: JST['contact_manager/contact_card']
  id: 'contact-card'
    
  events:
    'keyup input#contact-card-details-input': 'inputDetails'
    'click #contact-card-toggle-actions': 'toggleActionsBar'
    'submit #contact-card-details-input-form': 'submitDetails'

  initialize: ->
    @model.on('change', @render, this)

  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    @

  toggleActionsBar: ->
    if @actionsBarDisplayed
      $('#contact-card-actions').animate(
        width: '0px'
        opacity: '0'
      )
      $('#contact-card-toggle-actions i', @el)
        .removeClass('icon-chevron-right')
        .addClass('icon-chevron-left')
        @actionsBarDisplayed = false
    else
      $('#contact-card-actions').animate(
        width: '100%'
        opacity: '100'
      )
      $('#contact-card-toggle-actions i', @el)
        .removeClass('icon-chevron-left')
        .addClass('icon-chevron-right')
        @actionsBarDisplayed = true
    
  handleSuccess: (currentuser, response) =>
    id = response._id
    @model.get('favorite_ids').push(id)
    @model.save()
    
  handleDelete: (currentuser, response) =>
    id = response._id
    included = "test" in this.model.get('favorite_ids')
    @model.get('favorite_ids').pop(id)
    @model.save()

  inputDetails: (e) ->
    matcher = new RippleApp.Lib.DetailsMatcher(
      e.currentTarget.value
    )
    $('#contact-card-details-input-type', @el).html(matcher.topMatch())

  submitDetails: (e) ->
    e.preventDefault()
    console.log('BAM')
    console.log($('#contact-card-details-input', @el).val())
