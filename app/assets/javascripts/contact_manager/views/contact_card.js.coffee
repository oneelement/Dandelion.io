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
    'click #subject-delete': 'destroySubject'
    'show #socialModal': 'socialModalShow'
    
  initialize: ->
    @model.on('change', @render, this)
    @user = @options.user
    
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    
    favouriteIds = @user.get('favorite_ids')
    if favouriteIds
      if @model.get("_id") in favouriteIds
        $('#isFavourite', @el).attr('checked','checked')

#changed to multiple emails, OC
#    if @model.get('email')
#      email = new RippleApp.Views.ContactCardDetailSingle(
#        icon: 'envelope'
#        value: 'email'
#        model: @model
#      )
#      $('#contact-card-body-list', @el).append(email.render().el)
      
    if @model.get('dob')
      dob = new RippleApp.Views.ContactCardDetailSingle(
        icon: 'contact'
        value: 'dob'
        model: @model
      )
      $('#contact-card-body-list', @el).append(dob.render().el)
      
    $('#socialModal').modal()
          
    emailsSection = new RippleApp.Views.ContactCardSection(
      title: 'Emails'
      collection: @model.get("emails")
    )
    $('#contact-card-body', @el).append(emailsSection.render().el)
    
    phonesSection = new RippleApp.Views.ContactCardSection(
      title: 'Phone Numbers'
      collection: @model.get("phones")
    )
    $('#contact-card-body', @el).append(phonesSection.render().el)
    
    urlsSection = new RippleApp.Views.ContactCardSection(
      title: 'Urls'
      collection: @model.get("urls")
    )
    $('#contact-card-body', @el).append(urlsSection.render().el)

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
    
  destroySubject: ->
    getrid = confirm "Are you sure you want to delete this record?"
    if getrid == true
      this.model.destroy()
      Backbone.history.navigate('#contacts', true)
      #need to remove subject from recent contacts collection, OC

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
    #I have set this in the rails model, OC
    favouriteIds  = @user.get('favorite_ids') ? []    
    if e.target.checked
      favouriteIds.push(@model.get('_id'))
      _.uniq(favouriteIds) #does this actually work? OC, I think you might have to assign a variable
      @user.set('favorite_ids', favouriteIds)
      @user.save()
    else       
      index = favouriteIds.indexOf(@model.get('_id'))
      if index >= 0
        favouriteIds.splice(index, 1)
        @user.set('favorite_ids', favouriteIds)
        @user.save()
    
  #this function is now obsolete, OC
  handleSuccess: (currentuser, response) =>
    id = response._id
    @model.get('favorite_ids').push(id)
    @model.save()
  
  #this function is now obsolete, OC
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
      #console.log(formWidth)
      labelWidth = @calculateMatchLabelWidth(matchText, $addon)
      #console.log(labelWidth)
      inputWidth = formWidth - labelWidth
      #console.log(inputWidth)

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
      
      if _.include(['LinkedIn'], @match)
        c = @model.get("socials")
        exists = false        
        
        if c?
          for social in c.models 
            if social.attributes.social_id is val
              exists = true
              break
          
        if exists
          alert('duplicate alert!!')
        else
          m = new RippleApp.Models.ContactSocialDetail(
            _type: 'SocialLinkedin'
            social_id: val
          )
          c.add(m)
        
      if _.include(['Facebook'], @match)
        c = @model.get("socials")
        exists = false        
        
        if c?
          for social in c.models 
            if social.attributes.social_id is val
              exists = true
              break
          
        if exists
          alert('duplicate alert!!')
        else
          m = new RippleApp.Models.ContactSocialDetail(
            _type: 'SocialFacebook'
            social_id: val
          )
          c.add(m)
        
      if _.include(['Twitter'], @match)
        c = @model.get("socials")
        exists = false        
      
        if c?
          for social in c.models 
            if social.attributes.social_id is val
              exists = true
              break
          
        if exists
          alert('duplicate alert!!')
        else
          m = new RippleApp.Models.ContactSocialDetail(
            _type: 'SocialTwitter'
            social_id: val
          )
          c.add(m)
        
      if _.include(['Note'], @match)
        m = new RippleApp.Models.ContactNoteDetail(
          text: val
        )

        c = @model.get("notes")
        c.add(m)
      
      if _.include(['Email'], @match)
        m = new RippleApp.Models.ContactEmailDetail(
          email: val
          _type: 'EmailPersonal'
        )
        
        c = @model.get("emails")
        c.add(m)
        
      if _.include(['Url'], @match)
        m = new RippleApp.Models.ContactUrlDetail(
          url: val
          _type: 'UrlPersonal'
        )
        
        c = @model.get("urls")
        c.add(m)
      
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

  socialModalShow: (e) =>
    $('#socialModal input.socialSearch').typeahead(
      source: (typeahead, query) ->
        @faces = new RippleApp.Collections.Faces([], { call : "search/?q="+query })
        @faces.fetch(success: (collection) =>
          data = []
          _.each collection.models, (value, index) ->
            data.push({name:value.attributes.name, id:value.attributes.id})
          typeahead.process(data)
        )
      property: "name"
      items: 20
    )
