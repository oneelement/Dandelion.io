class RippleApp.Views.ContactsList extends Backbone.View
  template: JST['contact_manager/contact_list']
  tagName: 'tr'
  className: 'contact-list-item'
  
  initialize: ->
    @model.on('change', @render, this)
    @source = @options.source
    #@mergers = @options.mergers
    @selected = @options.selected
    @hashtags = RippleApp.contactsRouter.hashtags
    #console.log(@hashtags)
    #@hashtags.on('reset, add, remove', @render, this)
    @contactsHashtags = new RippleApp.Collections.Hashtags()
    @favouriteContacts = RippleApp.contactsRouter.favouriteContacts    
    @groups = RippleApp.contactsRouter.groups
    @user = RippleApp.contactsRouter.currentUser
    @user.on('change', @render, this)
    @modelType = @model.getModelName()
    @isSelected = false
    
  
  events:
    'click .contact-list-detail': 'previewContact'
    'dblclick': 'openContact'
    'click #merge-action': 'mergeSubject'
    'click .select': 'toggleSelect'
    

  render: ->
    $(@el).html(@template(contact: @model.toJSON(), modelType: @modelType))    
    @getSections()  
    #console.log('contacts list render')
    if @favouriteContacts.get(@model.get("_id"))
      this.$('.dicon-star').addClass('isFavorite')
    if @model.get('facebook_id')
      this.$('.dicon-facebook').addClass('facebook-active')
    if @model.get('twitter_id')
      this.$('.dicon-twitter').addClass('twitter-active')
    if @model.get('linkedin_id')
      this.$('.dicon-linkedin').addClass('linkedin-active')
      
    if @source == 'group_show'
      this.$('.select').html('')
      
    #console.log('rendering')
      
    return this
    
  toggleSelect: ->
    console.log(@selected)
    if @isSelected == false
      console.log('select')
      this.$('.dicon-checkmark').addClass('select-item')
      @selected.add(@model)
      @isSelected = true
      console.log(@selected)
    else 
      this.$('.dicon-checkmark').removeClass('select-item')
      @selected.remove(@model)
      @isSelected = false
      console.log(@selected)
    
  getSections: =>
    viewPhone = new RippleApp.Views.ContactListSection(collection: @model.get('phones'), subject: @model)
    this.$('.phone-details').append(viewPhone.render().el)    
    viewEmail = new RippleApp.Views.ContactListSection(collection: @model.get('emails'), subject: @model)
    this.$('.email-details').append(viewEmail.render().el)
    #if @model.get("hashtags")
    #  @contactsHashtags.reset()
    #  #console.log('resetting')
    #  @contactsHashtags.add(@model.get('hashtags'))
    #viewHash = new RippleApp.Views.ContactListSection(
    #  title: 'Hashtags'
    #  collection: @contactsHashtags
    #  subject: @model
    #  hashes: @hashtags
    #)
    #this.$('.hashtag-details').append(viewHash.render().el)
    @groupCollection = new RippleApp.Collections.Groups()
    if @model.get('group_ids')
      group_ids = @model.get('group_ids')
      _.each(group_ids, (group_id) =>
        group = @groups.get(group_id)
        if group
          @groupCollection.add(group)
      )
    viewGroup = new RippleApp.Views.ContactListSection(
      title: 'Groups'
      subject: @model
      collection: @model.get('emails')  
      groups: @groupCollection
    )
    this.$('.hashtag-details').append(viewGroup.render().el)
  
  previewContact: (event) ->
    if @model.getModelName() == 'contact'
      Backbone.history.navigate('#contacts/preview/' + @model.id, true)
    else if @model.getModelName() == 'group'
      Backbone.history.navigate('#groups/preview/' + @model.id, true)
    $('.contact-list-item').removeClass('selected')
    this.$('#merge-action').toggle()
    #console.log(@model)
    if $(this.el).hasClass('selected')
      $(this.el).removeClass('selected')
      #@mergers.remove(@model)
    else
      $(this.el).addClass('selected')
      #@mergers.add(@model)
      
  mergeSubject: (event) ->
    console.log(event)
    console.log(@mergers)
    leadContact = @mergers.at(0)
    console.log(leadContact)
    if @mergers.length > 1
      _.each(@mergers.models, (model) =>      
        #console.log(model)
        if model.get('_id') == @model.get('_id')
          console.log('woop')
        else
          phones = model.get('phones')
          mergePhones = @model.get('phones')
          if phones.length > 0
            _.each(phones.models, (phone) =>
              console.log(phone.get('number'))
              #phone.set('contact_id', @model.get('contact_id'))
              #phone.save()
              newPhone = new RippleApp.Models.ContactPhoneDetail()
              newPhone.set(number: phone.get('number'), _type: phone.get('_type'))
              mergePhones.add(newPhone)           
            )
          emails = model.get('emails')
          mergeEmails = @model.get('emails')
          if emails.length > 0
            _.each(emails.models, (email) =>
              newEmail = new RippleApp.Models.ContactEmailDetail()
              newEmail.set(email: email.get('email'), _type: email.get('_type'))
              mergeEmails.add(newEmail)           
            )
          notes = model.get('notes')
          mergeNotes = @model.get('notes')
          if notes.length > 0
            _.each(notes.models, (note) =>
              newNote = new RippleApp.Models.ContactNoteDetail()
              newNote.set(text: note.get('text'))
              mergeNotes.add(newNote)           
            )
          addresses = model.get('addresses')
          mergeAddresses = @model.get('addresses')
          if addresses.length > 0
            _.each(addresses.models, (address) =>
              newAddress = new RippleApp.Models.ContactAddressDetail()
              newAddress.set(full_address: address.get('full_address'), _type: address.get('_type'))
              mergeAddresses.add(newAddress)           
            )
          urls = model.get('urls')
          mergeUrls = @model.get('urls')
          if urls.length > 0
            _.each(urls.models, (url) =>
              newUrl = new RippleApp.Models.ContactUrlDetail()
              newUrl.set(url: url.get('url'), _type: url.get('_type'))
              mergeUrls.add(newUrl)           
            )
          model.destroy()
      )
      @model.save()
      Backbone.history.navigate('#contacts/preview/' + @model.get('_id'), true)
    
  openContact: ->
    Backbone.history.navigate('#contacts/show/'+ @model.id, true)
