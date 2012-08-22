class RippleApp.Views.AddContactCard extends Backbone.View
  template: JST['contact_manager/add_subject_card']
  searchModel: JST['contact_manager/search_modal']
  lightbox: JST['contact_manager/lightbox']
  matchOverrideList: JST['contact_manager/match_override_list']
  id: 'contact-card'
    
  events:
    'keypress #subject_name_input': 'checkNameEnter'

    
  initialize: ->
    @user = @options.user
    @model.on('change', @render, this)
    @contacts = RippleApp.contactsRouter.contacts
  
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    $(@el).append(@lightbox())
      
    @outputMap()
    @updateSocialLinks()
    
    return @
    
  outputMap: ->
    map = new RippleApp.Views.ContactCardMap(
      collection: @model.get("addresses")
    )
    $('#contact-card-map', @el).append(map.render().el)
    
  checkNameEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeNameEdit()
      
  closeNameEdit: ->
    this.model.set('name', this.$('input#subject_name_input').val())
    if @model.isNew() 
      modelname = @model.getModelName()
      if modelname == "contact"
        @model.unset('hashtags', { silent: true })
        @model.save(null, success: (model) => 
          @contacts.add(model)
          console.log(model)
          Backbone.history.navigate('#contacts/preview/'  + model.id, true)
        )
      else if modelname == "group"
        @model.unset('hashtags', { silent: true })
        @model.save(null, success: (model) => 
          RippleApp.contactsRouter.groups.add(model)
          Backbone.history.navigate('#groups/preview/'  + model.id, true)
        )

      
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
      

   