class RippleApp.Views.ContactProfile extends Backbone.View
  template: JST['contact_manager/contact_profile']
  id: 'contact-profile'
    
  events:
    'click .favorite-ind': 'checkFavorite'
    'keyup input#contact-profile-details-input': 'inputDetails'
    'click #contact-profile-toggle-actions': 'toggleActionsBar'

  initialize: ->
    @model.on('change', @render, this)

  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    @

  toggleActionsBar: ->
    if @actionsBarDisplayed
      $('#contact-profile-actions').animate(
        width: '0px'
        opacity: '0'
      )
      $('#contact-profile-toggle-actions i', @el)
        .removeClass('icon-chevron-right')
        .addClass('icon-chevron-left')
        @actionsBarDisplayed = false
    else
      $('#contact-profile-actions').animate(
        width: '100%'
        opacity: '100'
      )
      $('#contact-profile-toggle-actions i', @el)
        .removeClass('icon-chevron-left')
        .addClass('icon-chevron-right')
        @actionsBarDisplayed = true
    
  checkFavorite: ->
    if ($(this.el).hasClass('favorite'))
      $(this.el).removeClass('favorite')
      currentuser = new RippleApp.Models.Currentuser()
      currentuser.fetch({success: @handleDelete})
    else
      $(this.el).addClass('favorite')
      currentuser = new RippleApp.Models.Currentuser()
      currentuser.fetch({success: @handleSuccess})

	
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
    $('#matchtype', @el).html('[' + matcher.matchText + ']: ' + matcher.topMatch())
