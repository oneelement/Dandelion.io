class RippleApp.Views.ContactCard extends Backbone.View
  template: JST['contact_manager/contact_card']
  lightbox: JST['contact_manager/lightbox']
  matchOverrideList: JST['contact_manager/match_override_list']
  id: 'contact-card'
    
  events:
    'keyup #minibar-input-wrapper input': 'matchInputDetails'
    'focus #minibar-input-wrapper input': 'setMinibar'
    #'focusout #minibar-input-wrapper input': 'closeMinibar'
    #'click #minibar-wrapper': 'setMinibar'
    'click #isFavourite': 'toggleFavourite'
    'submit #contact-card-details-input-form': 'submitDetails'
    'click span.add-on': 'changeMatch'
    'click span.bp-select': 'changeBpType'
    'click .bp-type-list': 'setOverriddenType'
    'click #override-match-wrapper': 'setOverriddenMatch'
    'render': 'matchInputDetails'
    'click .Phone span.c-sm-icon-house, .Phone span.c-sm-icon-mobile': 'showPhoneModal'  
    'dblclick span.contact-detail-value': 'editValue'  
    'click #contact-card-name h3': 'editName'
    'keypress #subject_name_input': 'checkNameEnter'
    'focusout input#subject_name_input': 'closeNameEdit'
    'keypress #edit_value': 'checkEnter'
    #'focusout input#edit_value': 'closeEdit'
    'click #subject-delete': 'destroySubject'
    'click #subject-edit': 'editView'
    'click .main-icon': 'silentSave'
    'click .facebookSearch': 'facebookModal'
    'click .twitterSearch': 'twitterModal'
    'click .linkedinSearch': 'linkedinModal'
    'click .lionSearch': 'lionModal'
    'click .socialLinkButton': 'socialLink'
    'click .lionLinkButton': 'lionLink'
    #"click .Hashtags span.contact-detail-value": "clickHashtag"
    'click #contact-card-avatar': 'showAvatarLightbox'
    #'click span.delete-icon': 'saveModel'
    'click .map-present': 'showMapLightbox'
    'click #isRipple': 'rippleRequest'
    
  initialize: ->
    @user = @options.user
    @source = @options.source
    @favouriteContacts = RippleApp.contactsRouter.favouriteContacts
    @hashtags = RippleApp.contactsRouter.hashtags
    @groups = RippleApp.contactsRouter.groups
    @contactsHashtags = new RippleApp.Collections.Hashtags()
    @model.on('change', @render, this)
    @editViewOn = false
    @overrideMatch = false
    @overrideBp = false
    @auths = @user.get('authentications')
    @matchType = 'Personal'
  
  render: ->
    this.$('#minibar').focus()
    console.log('contact card rendering')
    $(@el).html(@template(contact: @model.toJSON(), source: @source))
    $(@el).append(@lightbox())
    if @favouriteContacts.get(@model.get("_id"))
      #$('#isFavourite', @el).attr('checked', 'checked')
      this.$('#isFavourite').addClass('isFavorite')
      
    @outputMap()

    @updateSocialLinks()
    
    if @model.get('linked_contact_id')
      this.$('#isRipple').addClass('visible')
      
    if @model.get('is_ripple') == true
      console.log(@model.get('is_ripple'))
      this.$('#isRipple').addClass('connected')
      this.$('div.searchIcon').removeClass('lionSearch')
      this.$('.dicon-network').addClass('dandelion-connected')
      @outputWithRippleDetails()
    else
      @outputCard()
      
    if @model.get('is_user') == true
      this.$('#isRipple').addClass('connected')
      
    #this.$('.contact-detail').addClass('editing')
    
    return @
    
  rippleRequest: ->
    if @model.get('is_ripple') == false
      if @model.get('is_user') == false
        @notification = new RippleApp.Models.Notification()
        sent_contact_id = @model.get('_id') #contact_id of this contact
        ripple_id = @model.get('ripple_id') #contact_id of target user
        @notification.set(
          _type: 'NotificationContactRipple'
          sent_contact_id: sent_contact_id
          ripple_id: ripple_id
        )
        console.log(@notification)
        @notification.save()

    
  showMapLightbox: ->
    $('#expanded-map').css('display','block')
    this.$('.lightboxmap').addClass('show').addClass('map')
    this.$('.lightboxmap').css('display', 'block')
    $('.lightbox-backdrop').css('display', 'block')
    map = new RippleApp.Views.LightboxMap(
      collection: @model.get("addresses")
    )
    $('.lightboxmap', @el).append(map.render().el)
    
  showAvatarLightbox: ->
    this.$('.lightbox').addClass('show').addClass('avatar')
    this.$('.lightbox').css('display', 'block')
    $('.lightbox-backdrop').css('display', 'block')
    view = new RippleApp.Views.LightboxAvatar(
      model: @model
    )
    $('.lightbox', @el).html(view.render().el)
    
  showSocialLightbox: ->
    this.$('.lightbox').addClass('show').addClass('social')
    this.$('.lightbox').css('display', 'block')
    $('.lightbox-backdrop').css('display', 'block')
    view = new RippleApp.Views.LightboxSocialSearch(
      model: @model
    )
    $('.lightbox', @el).html(view.render().el)
  
    
  #clickHashtag: (e)->
  #  id = @hashtags.getIdFromName(e.target.innerText)
  #  console.log(id)
  #  console.log(e.target)
  #  Backbone.history.navigate('#hashtags/show/'+id, true)
  
  outputMap: ->
    map = new RippleApp.Views.ContactCardMap(
      collection: @model.get("addresses")
    )
    $('#contact-card-map', @el).append(map.render().el)
    
  outputWithRippleDetails: ->
    id = @model.get('linked_contact_id')
    @user_contacts = RippleApp.contactsRouter.userContacts
    console.log(@user_contacts)
    @user_contact = @user_contacts.get(id)
    console.log(@user_contact)
     
    emailsSection = new RippleApp.Views.ContactUserSection(
      title: 'email'
      icon: 'paper-plane'
      collection: @user_contact.get("emails")
      subject: @model
      subjectCollection: @model.get("emails")
      modelName: RippleApp.Models.ContactEmailDetail
    )
    $('#contact-card-body', @el).append(emailsSection.render().el)
    
    @outputEmails()
    
    phonesSection = new RippleApp.Views.ContactUserSection(
      title: 'phone'
      icon: 'phone'
      collection: @user_contact.get("phones")
      subject: @model
      subjectCollection: @model.get("phones")
      modelName: RippleApp.Models.ContactPhoneDetail
    )
    $('#contact-card-body', @el).append(phonesSection.render().el)
    
    @outputPhones()
  
    urlsSection = new RippleApp.Views.ContactUserSection(
      title: 'website'
      icon: 'globe'
      collection: @user_contact.get("urls")
      subject: @model
      subjectCollection: @model.get("urls")
      modelName: RippleApp.Models.ContactUrlDetail
    )
    $('#contact-card-body', @el).append(urlsSection.render().el)
    
    @outputUrls()

     
    addressesSection = new RippleApp.Views.ContactUserSection(
      title: 'address'
      icon: 'location'
      collection: @user_contact.get("addresses")
      subject: @model
      subjectCollection: @model.get("addresses")
      modelName: RippleApp.Models.ContactAddressDetail
    )
    $('#contact-card-body', @el).append(addressesSection.render().el)
    
    @outputAdresses()
    
    positionsSection = new RippleApp.Views.ContactUserSection(
      title: 'position'
      icon: 'briefcase-3'
      collection: @user_contact.get("positions")
      subject: @model
      subjectCollection: @model.get("positions")
      modelName: RippleApp.Models.ContactAddressDetail
    )
    $('#contact-card-body', @el).append(positionsSection.render().el)
    
    @outputPositions()
    @outputEducations()
    @outputNotes()
    @outputGroups()
    #@outputHashes()


  outputCard: ->    
    if @model.get('location')
      dob = new RippleApp.Views.ContactCardDetailSingle(
        icon: 'location'
        value: 'location'
        model: @model
      )
      $('#contact-card-body-list', @el).append(dob.render().el)
    if @model.get('dob')
      dob = new RippleApp.Views.ContactCardDetailSingle(
        icon: 'contact'
        value: 'dob'
        model: @model
      )
      $('#contact-card-body-list', @el).append(dob.render().el)
    
    @outputEmails()
    @outputPhones()
    @outputUrls()
    @outputAdresses()
    @outputPositions()
    @outputEducations()
    @outputNotes()
    @outputGroups()
    #@outputHashes()
    
  outputEducations: ->
    educationsSection = new RippleApp.Views.ContactCardSection(
      title: 'education'
      icon: 'graduation'
      collection: @model.get("educations")
      subject: @model
      modelName: RippleApp.Models.ContactEducationDetail
    )
    $('#contact-card-body', @el).append(educationsSection.render().el)
    
  outputPositions: ->
    positionsSection = new RippleApp.Views.ContactCardSection(
      title: 'position'
      icon: 'briefcase-3'
      collection: @model.get("positions")
      subject: @model
      modelName: RippleApp.Models.ContactPositionDetail
    )
    $('#contact-card-body', @el).append(positionsSection.render().el)
          
  outputEmails: ->
    emailsSection = new RippleApp.Views.ContactCardSection(
      title: 'email'
      icon: 'paper-plane'
      collection: @model.get("emails")
      subject: @model
      modelName: RippleApp.Models.ContactEmailDetail
    )
    $('#contact-card-body', @el).append(emailsSection.render().el)
  
  outputPhones: ->  
    phonesSection = new RippleApp.Views.ContactCardSection(
      title: 'phone'
      icon: 'phone'
      collection: @model.get("phones")
      subject: @model
      modelName: RippleApp.Models.ContactPhoneDetail
    )
    $('#contact-card-body', @el).append(phonesSection.render().el)
    
  outputUrls: ->
    urlsSection = new RippleApp.Views.ContactCardSection(
      title: 'website'
      icon: 'globe'
      collection: @model.get("urls")
      subject: @model
      modelName: RippleApp.Models.ContactUrlDetail
    )
    $('#contact-card-body', @el).append(urlsSection.render().el)

  outputAdresses: ->
    addressesSection = new RippleApp.Views.ContactCardSection(
      title: 'address'
      icon: 'location'
      collection: @model.get("addresses")
      subject: @model
      modelName: RippleApp.Models.ContactAddressDetail
    )
    $('#contact-card-body', @el).append(addressesSection.render().el)
    
#    socialsSection = new RippleApp.Views.ContactCardSection(
#      title: 'Profile Links'
#      collection: @model.get("socials")
#      subject: @model
#      modelName: RippleApp.Models.ContactSocialDetail
#    )
#    $('#contact-card-body', @el).append(socialsSection.render().el)

  
  outputNotes: ->    
    if @model.get("notes").length != 0
      notesSection = new RippleApp.Views.ContactCardSection(
        title: 'note'
        icon: 'flag'
        collection: @model.get("notes")
        subject: @model
        modelName: RippleApp.Models.ContactNoteDetail
      )
      $('#contact-card-body', @el).append(notesSection.render().el) 
    
  outputGroups: ->    
    if @model.get('group_ids').length != 0
      collection = new RippleApp.Collections.Groups()
      groupSection = new RippleApp.Views.ContactCardGroupSection(
        title: 'group'
        icon: 'circles'
        subject: @model
        collection: collection
      )
      $('#contact-card-body', @el).append(groupSection.render().el)  
    
  outputHashes: ->    
    if @model.get("hashtags")
      @contactsHashtags.reset()
      @contactsHashtags.add(@model.get("hashtags"))
    hashtagSection = new RippleApp.Views.ContactCardHashtagSection(
      title: 'Tags'
      icon: 'tag'
      collection: @contactsHashtags
      subject: @model
      modelName: RippleApp.Models.Hashtag
      hashes: @hashtags
    )
    $('#contact-card-body', @el).append(hashtagSection.render().el)  
    
  editName: ->
    $(this.el).addClass('editing')
    this.$('#contact-card-name h3').css('display', 'none')
    this.$('#subject_name_input').css('display', 'inline-block')
    this.$('input#subject_name_input').focus()
    
  checkNameEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeNameEdit()
      
  closeNameEdit: ->
    #@model.unset('hashtags', { silent: true })
    val = this.$('input#subject_name_input').val()
    @model.set('name', val)
    @model.save('name', val, { silent: true })
    this.$('#contact-card-name h3').css('display', 'inline-block')
    this.$('#subject_name_input').css('display', 'none')
  
  editValue: ->
    $(this.el).addClass('editing')
    
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  silentSave: ->
    $(this.el).removeClass('editing')
    @model.unset('hashtags', { silent: true })
    @model.save(null, { silent: true })
    
  closeEdit: ->
    $(this.el).removeClass('editing')
    @model.unset('hashtags', { silent: true })
    @model.save(null, {wait: true})
    
  editView: ->
    console.log('Edit View')
    if @editViewOn == false
      $('.edit-view-input').css('display', 'block')
      $('.item-type').css('display', 'block')
      $('.dicon-pencil').addClass('active')

      this.$('.contact-detail').addClass('editing')
      this.$('.uneditable').removeClass('editing')
      this.$('.contact-card-section').addClass('editing')
      this.$('#contact-card-body-list').addClass('editing')
      
      @editViewOn = true
    else
      this.$('#contact-card-body-list').removeClass('editing')
      this.$('.contact-card-hashtag-section').removeClass('editing')
      this.$('.contact-card-section').removeClass('editing')
      this.$('.contact-detail').removeClass('editing')
      #$('.contact-card-section-title.active').css('display', 'block') #removed as titles no longer remain after edit
      $('.edit-view-input').css('display', 'none')
      $('.item-type').css('display', 'none')
      $('.dicon-pencil').removeClass('active')
      @editViewOn = false
    
  destroySubject: ->
    getrid = confirm "Are you sure you want to delete this record?"
    if getrid == true
      @favouriteContacts.remove(@model)
      RippleApp.contactsRouter.recentContacts.remove(@model)
      @user.set('favourite_contacts', JSON.stringify(@favouriteContacts))
      @user.set('recent_contacts', JSON.stringify(RippleApp.contactsRouter.recentContacts))
      @user.save()
      @model.destroy()
      #gotoContactId = RippleApp.contactsRouter.recentContacts.last().get('id')
      #Backbone.history.navigate('#contacts/show/'+gotoContactId, true)
      Backbone.history.navigate('#contacts', true)
      #I think after a delete its best to redirect to contacts, OC

 
  toggleFavourite: (e) ->   
    if @favouriteContacts.get(@model.get("_id"))
      @favouriteContacts.remove(@model.getBadge())
      this.$('#isFavourite').removeClass('isFavorite')
      @user.set('favourite_contacts', JSON.stringify(@favouriteContacts.toJSON()))
      @user.save()
    else
      @favouriteContacts.add(@model.getBadge())
      this.$('#isFavourite').addClass('isFavorite')
      @user.set('favourite_contacts', JSON.stringify(@favouriteContacts.toJSON()))
      @user.save()
      
  setMinibar: ->
    this.$('#minibar-type-wrapper').show()
    #this.$('#social-network-links').css('top', '140px')
    this.$('#contact-card-body').css('top', '178px')
    
  closeMinibar: ->
    this.$('#minibar-type-wrapper').hide()
    #this.$('#social-network-links').css('top', '115px')
    this.$('#contact-card-body').css('top', '153px')

  matchInputDetails: (e) ->
    #Display our guess of what the input text relates to, 
    #on the label alongside the input itself
    console.log('matching')
    if e.keyCode == 13
      @closeMinibar()
    else
      @setMinibar()

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

      if matchText is 'Group'
        $input.attr('style', "z-index: 9000;")   
        hashtags = []
        _.each(@hashtags.toJSON(), (hashtag)=>
          hashtags.push(hashtag.text)
        )
        console.log(hashtags)
        groups = []
        _.each(@groups.toJSON(), (group)=>
          entry = "#" + group.name
          groups.push(entry)
        )
        console.log(groups)
        $input.autocomplete
          source: groups
          appendTo: "#minibar-input-wrapper"
          select: (event, ui) =>
            @submitGroup(ui)
            
            
      else
        $input.autocomplete('destroy')  
      
      ##formWidth = $form.width()
      #console.log(formWidth)
      ##labelWidth = @calculateMatchLabelWidth(matchText, $addon)
      #console.log(labelWidth)
      ##inputWidth = formWidth - labelWidth
      #console.log(inputWidth)

      $matchLabel.fadeOut(100, ->
        #$input.animate({right: labelWidth}, 100)
        ##$input.animate({width: inputWidth - 10}, 100)
        $addon.animate(100, ->
          $matchLabel.text(matchText)
          $matchLabel.fadeIn(200))
      )
      
  changeBpType: ->
    if @overrideBp == false
      this.$('.bp-type-list').hide().slideDown(200)
      this.$('.bp-select .minibar-type-selected').css('border-bottom', '1px dotted #CCC')
      @overrideBp = true
    else
      this.$('.bp-type-list').slideUp(200, ->
        $('.bp-type-list').hide()
      )
      this.$('.bp-select .minibar-type-selected').css('border-bottom', 'none')
      @overrideBp = false
      
  setOverriddenType: (event) =>
    newMatch = this.$(event.target).text()    
    this.$('#bp-type').text(newMatch)
    @matchType = newMatch
    @overrideBp = true
    this.$('#minibar').focus()
    console.log(@matchType)
    
  changeMatch: ->
    console.log('Change Match')
    console.log(@overrideMatch)
    $form = $('#contact-card-details-input-form', @el)
    $addon = $('.add-on', $form)
    $input = $('input', $form)
    $matchLabel = $('#contact-card-details-input-type', $form)
    formWidth = $form.width()
    console.log(formWidth)
    inputWidth = formWidth - 118
    console.log(inputWidth)
    #matchtypes = ['Mobile', 'Home Phone', 'Email', 'Address', 'Url']
    if @overrideMatch == false
      this.$('#override-match-wrapper').hide().append(@matchOverrideList()).slideDown(200)
      this.$('.add-on .minibar-type-selected').css('border-bottom', '1px dotted #CCC')
      @overrideMatch = true
      #$matchLabel.fadeOut(100, ->
      #  $input.animate({width: inputWidth - 10}, 100)
      #  $addon.animate({left: inputWidth}, 100, ->
      #    $matchLabel.fadeIn(200))
      #)
    else
      this.$('#override-match-wrapper').slideUp(200, ->
        console.log('waiting...')
        $('#override-match-wrapper').html(''))
      this.$('.add-on .minibar-type-selected').css('border-bottom', 'none')
      @overrideMatch = false
      newMatch = this.$('#contact-card-details-input-type').text()
      ##labelWidth = @calculateMatchLabelWidth(newMatch, $addon)
      ##inputWidth = formWidth - labelWidth
      $matchLabel.fadeOut(100, ->
        ##$input.animate({width: inputWidth - 10}, 100)
        $addon.animate(100, ->
          $matchLabel.fadeIn(200))
      )
      
  setOverriddenMatch: (event) ->
    console.log(event)
    $form = $('#contact-card-details-input-form', @el)
    $input = $('input', $form)
    $addon = $('.add-on', $form)   
    $matchLabel = $('#contact-card-details-input-type', $form)
    newMatch = this.$(event.target).text()
    ##labelWidth = @calculateMatchLabelWidth(newMatch, $addon)
    ##formWidth = $form.width()
    ##inputWidth = formWidth - labelWidth
    this.$('#override-match-wrapper').html('')
    $matchLabel.fadeOut(100, ->
      #$input.animate({width: inputWidth - 10}, 100)
      $addon.animate(100, ->
        $matchLabel.text(newMatch)
        $matchLabel.fadeIn(200))
    )
    @match = newMatch
    @overrideMatch = true
    this.$('#minibar').focus()
    console.log(@match)
    
  submitGroup: (ui) =>
    this.$('#contact-card-details-input-type').text('...')
    test = $('input#minibar').val
    console.log(test)
    val = ui.item.value
    group_ids = @model.get("group_ids")
    c = new RippleApp.Collections.Groups()
    _.each(group_ids, (group_id) =>
      group = @groups.get(group_id)
      if group
        c.add(group)
    )
    
    isDuplicate = false
    _.each(c.models, (group) =>
      if group.get('name') is val
        isDuplicate = true
    )
    
    this.$('input#minibar').val('')
    
    if not isDuplicate
      #@contactsHashtags.remove(@contactsHashtags.models) #OC not sure what this is for?
      subject = @model.getModelName()
      subject_id = @model.get('_id')
      console.log('break')
      if subject == 'contact'
        newmodel = @groups.addGroupToSubject(val, subject_id, @model)
      if subject == 'group'
        newmodel = @groups.addGroupToSubject(val, subject_id, @model)
      this.$('#minibar').val('')

    else
      alert('duplicate')
    
    
    console.log(ui)
    console.log(val)
    


  submitDetails: (e) ->
    e.preventDefault()
    
    #@closeMinibar()

    $form = $('#contact-card-details-input-form', @el)
    $input = $('input', $form)    
    $matchLabel = $('#contact-card-details-input-type', $form)
    val = $input.val()
    $matchLabel.text('...')
    
    if @match
      if _.include(['Phone', 'Mobile'], @match)
        m = new RippleApp.Models.ContactPhoneDetail(
          number: val
        )
        c = @model.get("phones")

        if @match == 'Mobile'
          if @matchType == 'Personal'
            m.set('_type', 'MobilePersonal', {silent: true})
          else if @matchType == 'Business'
            m.set('_type', 'MobileBusiness', {silent: true})
        else if @match == 'Phone'
          if @matchType == 'Personal'
            m.set('_type', 'PhonePersonal', {silent: true})
          else if @matchType == 'Business'
            m.set('_type', 'PhoneBusiness', {silent: true})

        c.add(m)

      if _.include(['Address'], @match)
        m = new RippleApp.Models.ContactAddressDetail(
          full_address: val
        )

        c = @model.get("addresses")
        
        if @match == 'Address'
          if @matchType == 'Personal'
            m.set('_type', 'AddressPersonal', {silent: true})
          else if @matchType == 'Business'          
            m.set('_type', 'AddressBusiness', {silent: true})
          
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
          text: val
        )
        
        if @match == 'Email'
          if @matchType == 'Personal'
            m.set('_type', 'EmailPersonal', {silent: true})
          else if @matchType == 'Business'
            m.set('_type', 'EmailBusiness', {silent: true})
        
        c = @model.get("emails")
        c.add(m)
        
      if _.include(['Web'], @match)        
        m = new RippleApp.Models.ContactUrlDetail(
          text: val
        )
        
        if @match == 'Web'
          if @matchType == 'Personal'
            m.set('_type', 'UrlPersonal', {silent: true})
          else if @matchType == 'Business'
            m.set('_type', 'UrlBusiness', {silent: true})
            
        c = @model.get("urls")
        c.add(m)
        
      if _.include(['Group'], @match) 
      
        group_ids = @model.get("group_ids")
        c = new RippleApp.Collections.Groups()
        _.each(group_ids, (group_id) =>
          group = @groups.get(group_id)
          if group
            c.add(group)
        )
        
        isDuplicate = false
        _.each(c.models, (group) =>
            if group.get('name') is val
              isDuplicate = true
          )
        
        if not isDuplicate
          #@contactsHashtags.remove(@contactsHashtags.models) #OC not sure what this is for?
          subject = @model.getModelName()
          subject_id = @model.get('_id')
          console.log('break')
          if subject == 'contact'
            newmodel = @groups.addGroupToSubject(val, subject_id, @model)
          if subject == 'group'
            newmodel = @groups.addGroupToSubject(val, subject_id, @model)

        else
          alert('duplicate')
      
      if _.include(['Hashtag'], @match) 
      
        c = new RippleApp.Collections.Hashtags(@model.get("hashtags"))   
        #c = @model.get("hashtags")
        
        isDuplicate = false
        _.each(c.models, (hashtag) =>
            if hashtag.get('text') is val
              isDuplicate = true
          )
        
        if not isDuplicate
          #@contactsHashtags.remove(@contactsHashtags.models) #OC not sure what this is for?
          subject = @model.getModelName()
          subject_id = @model.get('_id')
          if subject == 'contact'
            newmodel = @hashtags.addTagToContact(val, subject_id)
          if subject == 'group'
            newmodel = @hashtags.addTagToGroup(val, subject_id)
          @contactsHashtags.add(newmodel)
          @hashModel = new RippleApp.Models.Hashtag()
          @hashModel.set(newmodel)
          @hashtags.add(@hashModel)
          console.log(@hashModel)
          @model.set('hashtags', @contactsHashtags.models, { silent: true })

        else
          alert('duplicate')
      
      if _.include(['D.O.B'], @match)
        @model.set('dob', val)

    $input.val('')
    $matchLabel.text('...')
    @model.unset('hashtags', { silent: true })
    @model.save(null, { silent: true })

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
    
  facebookSearch: (e) =>
    if e.keyCode == 13      
      @socials = new RippleApp.Collections.Faces([], { call : "search/?q="+e.target.value })
      $('.social-search-body ul').empty()
      $('.social-search-body ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((social)=>
            social.set('socialType', 'facebook_id')
            view = new RippleApp.Views.FaceSearch(model: social)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')

  facebookModal: (e) =>
    @showSocialLightbox()
    facebookauth = @auths.where(provider: "facebook")
    $('.social-search-header h3').html('Facebook Search')
    $('#social-search').val(@model.get('name'))
    if facebookauth.length > 0
      @faces = new RippleApp.Collections.Faces([], { call : "search/?q="+@model.get('name') })
      $('.social-search-body ul').empty().append("<li>Fetching...</li>")
      @faces.fetch(success: (collection) ->
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((face)=>
            face.set('socialType', 'facebook_id')
            view = new RippleApp.Views.FaceSearch(model: face)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      $('#social-search').on('keyup', @.facebookSearch)    
    else
      $('.social-search-body ul').append("<li><span class='dicon-info' style='color: #12CEF1;'> </span>Please link your Facebook account via the settings menu to search Facebook profiles.</li>")    
    
  twitterModal: (e)=>
    @showSocialLightbox()
    twitterauth = @auths.where(provider: "twitter")
    $('.social-search-header h3').html('Twitter Search')
    $('#social-search').val(@model.get('name'))
    if twitterauth.length > 0
      @tweets = new RippleApp.Collections.Tweets([], { call : "search/?q="+@model.get('name') })
      $('.social-search-body ul').empty().append("<li>Fetching...</li>")
      @tweets.fetch(success: (collection) ->
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((tweet)=>
            tweet.set('socialType', 'twitter_id')
            view = new RippleApp.Views.TwitterSearch(model: tweet)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      $('#social-search').on('keyup', @.twitterSearch)
    else
      $('.social-search-body ul').append("<li><span class='dicon-info' style='color: #12CEF1;'> </span>Please link your Twitter account via the settings menu to search Twitter profiles.</li>")
    
  twitterSearch: (e) =>
    if e.keyCode == 13      
      @socials = new RippleApp.Collections.Tweets([], { call : "search/?q="+e.target.value })
      $('.social-search-body ul').empty()
      $('.social-search-body ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((social)=>
            social.set('socialType', 'twitter_id')
            view = new RippleApp.Views.TwitterSearch(model: social)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')
      
  linkedinModal: (e) =>
    @showSocialLightbox()
    linkedinauth = @auths.where(provider: "linkedin")
    $('.social-search-header h3').html('Linkedin Search')
    $('#social-search').val(@model.get('name'))
    if linkedinauth.length > 0
      @linkedin = new RippleApp.Collections.Linkedins([], { call : "search/?q="+@model.get('name') })
      $('.social-search-body ul').empty().append("<li>Fetching...</li>")
      @linkedin.fetch(success: (collection) ->
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((link)=>
            link.set('socialType', 'linkedin_id')
            view = new RippleApp.Views.LinkedinSearch(model: link)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      $('#social-search').on('keyup', @.linkedinSearch)
    else
      $('.social-search-body ul').append("<li><span class='dicon-info' style='color: #12CEF1;'> </span>Please link your Linkedin account via the settings menu to search Linked In profiles.</li>")
    
  linkedinSearch: (e) =>
    if e.keyCode == 13      
      @socials = new RippleApp.Collections.Linkedins([], { call : "search/?q="+e.target.value })
      $('.social-search-body ul').empty()
      $('.social-search-body ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((social)=>
            social.set('socialType', 'linkedin_id')
            view = new RippleApp.Views.LinkedinSearch(model: social)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')
    
    
          
  lionModal: (e) =>
    @showSocialLightbox()
    #linkedinauth = @auths.where(provider: "linkedin")
    $('.social-search-header h3').html('Dandelion Search')
    $('#social-search').val(@model.get('name'))
    name = @model.get('name')
    @lions = new RippleApp.Collections.PublicUsers([], { call : "/?name="+@model.get('name') })
    $('.social-search-body ul').empty().append("<li>Fetching...</li>")
    @lions.fetch(success: (collection) =>
      if collection.length > 0
        $('.social-search-body ul').empty()
        collection.each((link) =>
          if @model.get('linked_contact_id') == link.get('contact_id')
            link.set('awaiting', 'true')
          console.log(@model.get('linked_contact_id'))
          console.log(link.get('contact_id'))
          $('.social-search-body ul').empty()
          link.set('socialType', 'linked_contact_id')
          view = new RippleApp.Views.LionSearch(model: link)
          $('.social-search-body ul').append(view.render().el)
        )
      else
        $('.social-search-body ul').empty().append("<li>No results to display</li>")
    )
    $('#social-search').on('keyup', @.lionSearch)
      
      
  lionSearch: (e) =>
    if e.keyCode == 13      
      @socials = new RippleApp.Collections.PublicUsers([], { call : "/?name="+e.target.value })
      $('.social-search-body ul').empty()
      $('.social-search-body ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('.social-search-body ul').empty()
          collection.each((social)=>
            if @model.get('linked_contact_id') == social.get('contact_id')
              social.set('awaiting', 'true')
            console.log(@model.get('linked_contact_id'))
            console.log(social.get('contact_id'))
            social.set('socialType', 'linked_contact_id')
            view = new RippleApp.Views.LionSearch(model: social)
            $('.social-search-body ul').append(view.render().el)
          )
        else
          $('.social-search-body ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')

  lionLink: (e) =>
    target_user_id = $(e.target).attr('data-user-id')
    target_user_contact_id = $(e.target).attr('data-contact-id')
    if @model.get('is_ripple') == false
      if @model.get('is_user') == false
        @notification = new RippleApp.Models.Notification()
        sent_contact_id = @model.get('_id') #contact_id of this contact
        #ripple_id = @model.get('ripple_id') #contact_id of target user
        @notification.set(
          _type: 'NotificationContactRipple'
          sent_contact_id: sent_contact_id
          ripple_id: @model.get('_id')
          user_id: target_user_id
        )
        console.log(@notification)
        @notification.save() 
    @model.set('linked_contact_id', target_user_contact_id, { silent: true })
    @model.save(null, { silent: true })
 
  socialLink: (e) =>
    socialType = $(e.target).attr('data-socialtype')
    social_id = $(e.target).attr('data-socialid')
    pictureUrl = $(e.target).attr('data-pictureurl')
    handle = $(e.target).attr('data-handle')
    if socialType == "facebook_id"
      pictureType = "facebook_picture"
      handleType = "facebook_handle"
    if socialType == "twitter_id"
      pictureType = "twitter_picture"
      handleType = "twitter_handle"
    if socialType == "linkedin_id"
      pictureType = "linkedin_picture"   
      handleType = "linkedin_handle"
    @model.set(handleType, handle, {silent: true})
    @model.set(pictureType, pictureUrl, {silent: true})
    @model.set(socialType, social_id) #let the set fire the render
    #@model.unset('hashtags', { silent: true })
    @model.save(null, { silent: true }) #required so social links dont get fired twice
    @updateSocialLinks()
    $('.lightbox-backdrop').css('display', 'none')
    $('.lightbox').removeClass('show')
    $('.lightbox').removeClass('social')
    $('.lightbox').css('display', 'none')
    $('.lightbox').html('')

    
  updateSocialLinks: ()=>
    if @model.get('facebook_handle')
      $('#social-network-links a.dicon-facebook', @el).removeAttr('style').attr('href', @model.get('facebook_handle')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('facebookSearch')
      this.$('.dicon-facebook').removeClass('social-grey')
      this.$('.dicon-facebook').addClass('social-facebook')
    else
      $('#social-network-links a.facebook', @el).attr('data-toggle', 'modal').attr('style', 'background-color:#CFCFCF;')
      
    if @model.get('twitter_handle')
      $('#social-network-links a.dicon-twitter', @el).removeAttr('style').attr('href', @model.get('twitter_handle')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('twitterSearch')
      this.$('.dicon-twitter').removeClass('social-grey')
      this.$('.dicon-twitter').addClass('social-twitter')
    else
      $('#social-network-links a.twitter', @el).attr('style', 'background-color:#CFCFCF;')
      
    if @model.get('linkedin_handle')
      $('#social-network-links a.dicon-linkedin', @el).removeAttr('style').attr('href', @model.get('linkedin_handle')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('linkedinSearch')
      this.$('.dicon-linkedin').removeClass('social-grey')
      this.$('.dicon-linkedin').addClass('social-linkedin')
    else
      $('#social-network-links a.linkedin', @el).attr('style', 'background-color:#CFCFCF;')
      
  showPhoneModal: (e)=>
    grannyView = new RippleApp.Views.GrannyPhoneCard(
      collection: @model.get('phones')
    )
    $('#granny-phone-card').remove()
    $('body').append(grannyView.render().el)
    modalWidth = $(window).width()*0.8
    $('#granny-phone-card').attr('style','width:'+modalWidth+'px; margin-left:-'+(modalWidth/2)+'px;')
    $('#granny-phone-card').reveal()
    
  saveModel: =>
    @model.unset('hashtags', { silent: true })
    @model.save()
   