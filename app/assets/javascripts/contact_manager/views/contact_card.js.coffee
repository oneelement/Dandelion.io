class RippleApp.Views.ContactCard extends Backbone.View
  template: JST['contact_manager/contact_card']
  id: 'contact-card'
    
  events:
    'keyup #contact-card-details-input input': 'matchInputDetails'
    'click #contact-card-toggle-actions': 'toggleActionsBar'
    'click #isFavourite': 'toggleFavourite'
    'submit #contact-card-details-input-form': 'submitDetails'
    'render': 'matchInputDetails'
    'dblclick span.contact-detail-value': 'editValue'    
    'keypress #edit_value': 'checkEnter'
    'focusout input#edit_value': 'closeEdit'
    
  initialize: ->
    @model.on('change', @render, this)
    @user = @options.user
    console.log(@user)
    favouriteIds = @user.get('favorite_ids')
    if favouriteIds
      if @model._id in favouriteIds
        $('#isFavourite', @el).attr('checked','checked')
    
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    if @model.get('email')
      email = new RippleApp.Views.ContactCardDetailSingle(
        icon: 'envelope'
        value: 'email'
        model: @model
      )
      $('#contact-card-body-list', @el).append(email.render().el)
      
    if @model.get('dob')
      email = new RippleApp.Views.ContactCardDetailSingle(
        icon: 'contact'
        value: 'dob'
        model: @model
      )
      $('#contact-card-body-list', @el).append(email.render().el)
    
    phonesSection = new RippleApp.Views.ContactCardSection(
      title: 'Phone Numbers'
      collection: @model.get("phones")
    )
    $('#contact-card-body', @el).append(phonesSection.render().el)

    addressesSection = new RippleApp.Views.ContactCardSection(
      title: 'Addresses'
      collection: @model.get("addresses")
    )
    $('#contact-card-body', @el).append(addressesSection.render().el)
    
    socialsSection = new RippleApp.Views.ContactCardSection(
      title: 'Profile Links'
      collection: @model.get("socials")
    )
    $('#contact-card-body', @el).append(socialsSection.render().el)
    
    notesSection = new RippleApp.Views.ContactCardSection(
      title: 'Notes'
      collection: @model.get("notes")
    )
    $('#contact-card-body', @el).append(notesSection.render().el)
    
    return @

  editValue: ->
    $(this.el).addClass('editing')
    
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    $(this.el).removeClass('editing')
    @model.save()

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
  
  toggleFavourite: (e) ->
    #want to set favourite_ids default to [] but neither contact or user model seem to work. ew
    favouriteIds  = @user.get('favorite_ids') ? []
    
    if e.target.checked
      favouriteIds.push(@model.get('_id'))
      @user.set('favorite_ids', favouriteIds)
      console.log(@user)
      @user.save()
    else       
      index = favouriteIds.indexOf(@model.get('_id'))
      if index >= 0
        favouriteIds.splice(index, 1)
        @user.set('favorite_ids', favouriteIds)
        console.log(@user)
        @user.save()
    
  handleSuccess: (currentuser, response) =>
    id = response._id
    @model.get('favorite_ids').push(id)
    @model.save()
    
  handleDelete: (currentuser, response) =>
    id = response._id
    included = "test" in this.model.get('favorite_ids')
    @model.get('favorite_ids').pop(id)
    @model.save()

  matchInputDetails: ->
    #Display our guess of what the input text relates to, 
    #on the label alongside the input itself

    $form = $('#contact-card-details-input-form', @el)
    $input = $('input', $form)
    $addon = $('.add-on', $form)
    $matchLabel = $('#contact-card-details-input-type', $form)

    if not @inputTypeDefaultLabel?
      @inputTypeDefaultLabel = $matchLabel.text()

    matcher = new RippleApp.Lib.DetailsMatcher($input.val())
    
    if @match != matcher.topMatch()
      @match = matcher.topMatch()

      matchText = matcher.topMatch()
      if not matchText?
        matchText = @inputTypeDefaultLabel

      formWidth = $form.width()
      console.log(formWidth)
      labelWidth = @calculateMatchLabelWidth(matchText, $addon)
      console.log(labelWidth)
      inputWidth = formWidth - labelWidth
      console.log(inputWidth)

      $matchLabel.fadeOut(100, ->
        #$input.animate({right: labelWidth}, 100)
        $input.animate({width: inputWidth - 10}, 100)
        $addon.animate({left: inputWidth}, 100, ->
          $matchLabel.text(matchText)
          $matchLabel.fadeIn(200))
      )


  submitDetails: (e) ->
    e.preventDefault()

    $form = $('#contact-card-details-input-form', @el)
    $input = $('input', $form)
    val = $input.val()

    if @match
      if _.include(['Mobile', 'Home Phone'], @match)
        m = new RippleApp.Models.ContactPhoneDetail(
          number: val
        )
        c = @model.get("phones")

        if @match == 'Mobile'
          m.set('_type', 'PhoneMobile')
        else if @match == 'Home Phone'
          m.set('_type', 'PhoneHome')

        c.add(m)

      if _.include(['Address'], @match)
        m = new RippleApp.Models.ContactAddressDetail(
          _type: 'AddressHome'
          full_address: val
        )

        c = @model.get("addresses")
        c.add(m)

      if _.include(['Note'], @match)
        m = new RippleApp.Models.ContactNoteDetail(
          text: val
        )

        c = @model.get("notes")
        c.add(m)
      
      if _.include(['Email'], @match)
        @model.set('email', val)
      
      if _.include(['D.O.B'], @match)
        @model.set('dob', val)

    $input.val('')
    @model.save()

  calculateMatchLabelWidth: (text, $addon) ->
    textWidth = @measureTextWidth(text)
    addonPadding = $addon.innerWidth() - $addon.width()

    return textWidth + (2 * addonPadding)

  measureTextWidth: (text) ->
    $ruler = $('<div></div>').css('visibility', 'hidden').css('position', 'absolute').css('width', 'auto').css('height', 'auto')
    $('body').append($ruler)
    $ruler.text(text)

    w = $ruler.width()
    $ruler.remove()
    return w
