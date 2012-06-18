class RippleApp.Views.ContactCard extends Backbone.View
  template: JST['contact_manager/contact_card']
  searchModel: JST['contact_manager/search_modal']
  pictureModel: JST['contact_manager/picture_modal']
  matchOverrideList: JST['contact_manager/match_override_list']
  id: 'contact-card'
    
  events:
    'keyup #contact-card-details-input input': 'matchInputDetails'
    'click #contact-card-toggle-actions': 'toggleActionsBar'
    'click #isFavourite': 'toggleFavourite'
    'submit #contact-card-details-input-form': 'submitDetails'
    'click span.add-on': 'changeMatch'
    'click #override-matcher': 'setOverriddenMatch'
    'render': 'matchInputDetails'
    'click .Phone span.c-sm-icon-house, .Phone span.c-sm-icon-mobile': 'showPhoneModal'  
    'dblclick span.contact-detail-value': 'editValue'  
    'dblclick #contact-card-name': 'editName'
    'keypress #subject_name_input': 'checkNameEnter'
    'focusout input#subject_name_input': 'closeNameEdit'
    'keypress #edit_value': 'checkEnter'
    'focusout input#edit_value': 'closeEdit'
    'click #subject-delete': 'destroySubject'
    'click #subject-edit': 'editView'
    'click #default-phone, #default-address, #default-email': 'closeEdit'
    'click .facebookSearch': 'facebookModal'
    'click .twitterSearch': 'twitterModal'
    'click .linkedinSearch': 'linkedinModal'
    'click .socialLinkButton': 'socialLink'
    #"click .Hashtags span.contact-detail-value": "clickHashtag"
    'show #avatar-modal': 'avatarModal'
    #'click span.delete-icon': 'saveModel'
    
  initialize: ->
    @user = @options.user
    @favouriteContacts = RippleApp.contactsRouter.favouriteContacts
    @hashtags = RippleApp.contactsRouter.hashtags
    @contactsHashtags = new RippleApp.Collections.Hashtags()
    @model.on('change', @render, this)
    @editViewOn = false
    @overrideMatch = false
  
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))

    $(@el).append(@searchModel(options: {title: "Facebook Search"}))
    $(@el).append(@pictureModel(subject: @model.toJSON(), options: {title: "Select Avatar"}))
    $('#social-modal', @el).modal(show: false)
    if @favouriteContacts.get(@model.get("_id"))
      $('#isFavourite', @el).attr('checked', 'checked')

    @updateSocialLinks()
    @outputCard()
    
    return @
    
  avatarModal: ->
    $('#avatar-select-container', @el).html('')
    if @model.get('linkedin_picture')
      console.log(@model.get('linkedin_id'))
      url = @model.get('linkedin_picture')      
      view = new RippleApp.Views.AvatarSelect(url: url, model: @model)
      $('#avatar-select-container', @el).append(view.render().el)
    if @model.get('facebook_picture')
      url = @model.get('facebook_picture')
      view = new RippleApp.Views.AvatarSelect(url: url, model: @model)
      $('#avatar-select-container', @el).append(view.render().el)
    if @model.get('twitter_picture')
      url = @model.get('twitter_picture')
      twitter_id = @model.get('twitter_id')
      view = new RippleApp.Views.AvatarSelect(url: url, model: @model)
      $('#avatar-select-container', @el).append(view.render().el)
    
  #clickHashtag: (e)->
  #  id = @hashtags.getIdFromName(e.target.innerText)
  #  console.log(id)
  #  console.log(e.target)
  #  Backbone.history.navigate('#hashtags/show/'+id, true)

  outputCard: ->      
    if @model.get('dob')
      dob = new RippleApp.Views.ContactCardDetailSingle(
        icon: 'contact'
        value: 'dob'
        model: @model
      )
      $('#contact-card-body-list', @el).append(dob.render().el)
          
    emailsSection = new RippleApp.Views.ContactCardSection(
      title: 'Emails'
      collection: @model.get("emails")
      subject: @model
      modelName: RippleApp.Models.ContactEmailDetail
    )
    $('#contact-card-body', @el).append(emailsSection.render().el)
    
    phonesSection = new RippleApp.Views.ContactCardSection(
      title: 'Phone Numbers'
      collection: @model.get("phones")
      subject: @model
      modelName: RippleApp.Models.ContactPhoneDetail
    )
    $('#contact-card-body', @el).append(phonesSection.render().el)
    
    urlsSection = new RippleApp.Views.ContactCardSection(
      title: 'Urls'
      collection: @model.get("urls")
      subject: @model
      modelName: RippleApp.Models.ContactUrlDetail
    )
    $('#contact-card-body', @el).append(urlsSection.render().el)

    addressesSection = new RippleApp.Views.ContactCardSection(
      title: 'Addresses'
      collection: @model.get("addresses")
      subject: @model
      modelName: RippleApp.Models.ContactAddressDetail
    )
    $('#contact-card-body', @el).append(addressesSection.render().el)
    
    socialsSection = new RippleApp.Views.ContactCardSection(
      title: 'Profile Links'
      collection: @model.get("socials")
      subject: @model
      modelName: RippleApp.Models.ContactSocialDetail
    )
    $('#contact-card-body', @el).append(socialsSection.render().el)
    
    notesSection = new RippleApp.Views.ContactCardSection(
      title: 'Notes'
      collection: @model.get("notes")
      subject: @model
      modelName: RippleApp.Models.ContactNoteDetail
    )
    $('#contact-card-body', @el).append(notesSection.render().el)  
    
    @contactsHashtags.add(@model.get("hashtags"))
    hashtagSection = new RippleApp.Views.ContactCardSection(
      title: 'Hashtags'
      collection: @contactsHashtags
      subject: @model
      modelName: RippleApp.Models.Hashtag
      hashes: @hashtags
    )
    $('#contact-card-body', @el).append(hashtagSection.render().el)  
    
  editName: ->
    $(this.el).addClass('editing')
    this.$('#contact-card-name h3').css('display', 'none')
    this.$('#subject_name_input').css('display', 'block')
    this.$('input#subject_name_input').focus()
    
  checkNameEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeNameEdit()
      
  closeNameEdit: ->
    @model.unset('hashtags', { silent: true })
    @model.save('name', this.$('input#subject_name_input').val())
    this.$('#contact-card-name h3').css('display', 'block')
    this.$('#subject_name_input').css('display', 'none')
  
  editValue: ->
    $(this.el).addClass('editing')
    
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    $(this.el).removeClass('editing')
    @model.unset('hashtags', { silent: true })
    @model.save(null, {wait: true})
    
  editView: ->
    console.log('Edit View')
    if @editViewOn == false
      $('.contact-card-section-title').css('display', 'block')
      $('.subject_edit_view_input').css('display', 'block')
      $('.item-type').css('display', 'block')
      @editViewOn = true
    else
      $('.contact-card-section-title').css('display', 'none')
      $('.contact-card-section-title.active').css('display', 'block')
      $('.subject_edit_view_input').css('display', 'none')
      $('.item-type').css('display', 'none')
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
    if e.target.checked
      @favouriteContacts.add(@model.getBadge())
      @user.set('favourite_contacts', JSON.stringify(@favouriteContacts.toJSON()))
      @user.save()
    else
      @favouriteContacts.remove(@model.getBadge())
      @user.set('favourite_contacts', JSON.stringify(@favouriteContacts.toJSON()))
      @user.save()

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

      if matchText is 'Hashtag'
        $input.attr('style', "z-index: 9000;")   
        hashtags = []
        _.each(@hashtags.toJSON(), (hashtag)=>
          hashtags.push(hashtag.text)
        )
        $input.autocomplete(source: hashtags)
      else
        $input.autocomplete('destroy')  
      
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
      
  changeMatch: ->
    console.log('Change Match')
    console.log(@overrideMatch)
    $form = $('#contact-card-details-input-form', @el)
    $addon = $('.add-on', $form)
    $input = $('input', $form)
    $matchLabel = $('#contact-card-details-input-type', $form)
    formWidth = $form.width()
    inputWidth = formWidth - 118
    matchtypes = ['Mobile', 'Home Phone']
    if @overrideMatch == false
      this.$('#override-match-wrapper').hide().append(@matchOverrideList()).slideDown(200)
      @overrideMatch = true
      $matchLabel.fadeOut(100, ->
        $input.animate({width: inputWidth - 10}, 100)
        $addon.animate({left: inputWidth}, 100, ->
          $matchLabel.fadeIn(200))
      )
    else
      this.$('#override-match-wrapper').slideUp(200, ->
        console.log('waiting...')
        $('#override-match-wrapper').html(''))
      @overrideMatch = false
      newMatch = this.$('#contact-card-details-input-type').text()
      labelWidth = @calculateMatchLabelWidth(newMatch, $addon)
      inputWidth = formWidth - labelWidth
      $matchLabel.fadeOut(100, ->
        $input.animate({width: inputWidth - 10}, 100)
        $addon.animate({left: inputWidth}, 100, ->
          $matchLabel.fadeIn(200))
      )
      
  setOverriddenMatch: (event) ->
    console.log(event)
    $form = $('#contact-card-details-input-form', @el)
    $input = $('input', $form)
    $addon = $('.add-on', $form)   
    $matchLabel = $('#contact-card-details-input-type', $form)
    newMatch = this.$(event.target).text()
    labelWidth = @calculateMatchLabelWidth(newMatch, $addon)
    formWidth = $form.width()
    inputWidth = formWidth - labelWidth
    this.$('#override-match-wrapper').html('')
    $matchLabel.fadeOut(100, ->
      $input.animate({width: inputWidth - 10}, 100)
      $addon.animate({left: inputWidth}, 100, ->
        $matchLabel.text(newMatch)
        $matchLabel.fadeIn(200))
    )
    @match = newMatch
    @overrideMatch = false


  submitDetails: (e) ->
    e.preventDefault()

    $form = $('#contact-card-details-input-form', @el)
    $input = $('input', $form)    
    $matchLabel = $('#contact-card-details-input-type', $form)
    val = $input.val()
    $matchLabel.html('')
    
    if @match
      if _.include(['Mobile', 'Home Phone'], @match)
        m = new RippleApp.Models.ContactPhoneDetail(
          number: val
        )
        c = @model.get("phones")

        if @match == 'Mobile'
          m.set('_type', 'PhoneMobile', {silent: true})
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
      
      if _.include(['Hashtag'], @match) 
      
        c = new RippleApp.Collections.Hashtags(@model.get("hashtags"))      
        
        isDuplicate = false
        _.each(c.models, (hashtag) =>
            if hashtag.get('text') is val
              isDuplicate = true
          )
        
        if not isDuplicate
          @contactsHashtags.remove(@contactsHashtags.models)
          subject = @model.getModelName()
          subject_id = @model.get('_id')
          if subject == 'contact'
            newmodel = @hashtags.addTagToContact(val, subject_id)
          if subject == 'group'
            newmodel = @hashtags.addTagToGroup(val, subject_id)
          @contactsHashtags.add(newmodel)
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
      $('#social-modal ul').empty()
      $('#social-modal ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('#social-modal ul').empty()
          collection.each((social)=>
            social.set('socialType', 'facebook_id')
            view = new RippleApp.Views.FaceSearch(model: social)
            $('#social-modal ul').append(view.render().el)
          )
        else
          $('#social-modal ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')

  facebookModal: (e) =>
    $('#social-search').val(@model.get('name'))
    @faces = new RippleApp.Collections.Faces([], { call : "search/?q="+@model.get('name') })
    $('#social-modal ul').empty().append("<li>Fetching...</li>")
    @faces.fetch(success: (collection) ->
      if collection.length > 0
        $('#social-modal ul').empty()
        collection.each((face)=>
          face.set('socialType', 'facebook_id')
          view = new RippleApp.Views.FaceSearch(model: face)
          $('#social-modal ul').append(view.render().el)
        )
      else
        $('#social-modal ul').empty().append("<li>No results to display</li>")
    )
    $('#social-search').on('keyup', @.facebookSearch)    
    
  twitterModal: (e)=>
    $('.modal-header h3').html('Twitter Search')
    $('#social-search').val(@model.get('name'))
    @tweets = new RippleApp.Collections.Tweets([], { call : "search/?q="+@model.get('name') })
    $('#social-modal ul').empty().append("<li>Fetching...</li>")
    @tweets.fetch(success: (collection) ->
      if collection.length > 0
        $('#social-modal ul').empty()
        collection.each((tweet)=>
          tweet.set('socialType', 'twitter_id')
          view = new RippleApp.Views.TwitterSearch(model: tweet)
          $('#social-modal ul').append(view.render().el)
        )
      else
        $('#social-modal ul').empty().append("<li>No results to display</li>")
    )
    $('#social-search').on('keyup', @.twitterSearch)
    
  twitterSearch: (e) =>
    if e.keyCode == 13      
      @socials = new RippleApp.Collections.Tweets([], { call : "search/?q="+e.target.value })
      $('#social-modal ul').empty()
      $('#social-modal ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('#social-modal ul').empty()
          collection.each((social)=>
            social.set('socialType', 'twitter_id')
            view = new RippleApp.Views.TwitterSearch(model: social)
            $('#social-modal ul').append(view.render().el)
          )
        else
          $('#social-modal ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')
      
  linkedinModal: (e) =>
    $('.modal-header h3').html('Linkedin Search')
    $('#social-search').val(@model.get('name'))
    @linkedin = new RippleApp.Collections.Linkedins([], { call : "search/?q="+@model.get('name') })
    $('#social-modal ul').empty().append("<li>Fetching...</li>")
    @linkedin.fetch(success: (collection) ->
      if collection.length > 0
        $('#social-modal ul').empty()
        console.log(collection)
        console.log(collection.people)
        collection.each((link)=>
          link.set('socialType', 'linkedin_id')
          view = new RippleApp.Views.LinkedinSearch(model: link)
          $('#social-modal ul').append(view.render().el)
        )
      else
        $('#social-modal ul').empty().append("<li>No results to display</li>")
    )
    $('#social-search').on('keyup', @.linkedinSearch)
    
  linkedinSearch: (e) =>
    if e.keyCode == 13      
      @socials = new RippleApp.Collections.Linkedins([], { call : "search/?q="+e.target.value })
      $('#social-modal ul').empty()
      $('#social-modal ul').append("<li>Fetching...</li>")
      @socials.fetch(success: (collection) =>  
        if collection.length > 0
          $('#social-modal ul').empty()
          collection.each((social)=>
            social.set('socialType', 'linkedin_id')
            view = new RippleApp.Views.LinkedinSearch(model: social)
            $('#social-modal ul').append(view.render().el)
          )
        else
          $('#social-modal ul').empty().append("<li>No results to display</li>")
      )
      #$('#social-search').off('keyup')
    
  socialLink: (e)=>
    socialType = $(e.target).attr('data-socialtype')
    social_id = $(e.target).attr('data-socialid')
    pictureUrl = $(e.target).attr('data-pictureurl')
    if socialType == "facebook_id"
      pictureType = "facebook_picture"
    if socialType == "twitter_id"
      pictureType = "twitter_picture"
    if socialType == "linkedin_id"
      pictureType = "linkedin_picture"   
    @model.set(pictureType, pictureUrl, {silent: true})
    @model.set(socialType, social_id, pictureType, pictureUrl)
    @model.unset('hashtags', { silent: true })
    @model.save()
    @updateSocialLinks()
    $('#social-modal').modal('hide')
    
  updateSocialLinks: ()=>
    facebook_id = @model.get('facebook_id')
    if facebook_id
      $('#social-network-links a.facebook', @el).removeAttr('style').removeAttr('data-toggle').attr('href', 'http://www.facebook.com/'+facebook_id).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('facebookSearch')
    else
      $('#social-network-links a.facebook', @el).attr('data-toggle', 'modal').attr('style', 'background-color:#CFCFCF;')
      
    if @model.get('twitter_id')
      $('#social-network-links a.twitter', @el).removeAttr('style').removeAttr('data-toggle').attr('href', 'http://www.twitter.com/'+@model.get('twitter_id')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('twitterSearch')
    else
      $('#social-network-links a.twitter', @el).attr('style', 'background-color:#CFCFCF;')
      
    if @model.get('linkedin_id')
      $('#social-network-links a.linkedin', @el).removeAttr('style').removeAttr('data-toggle').attr('href', @model.get('linkedin_id')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('linkedinSearch')
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
   