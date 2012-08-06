class RippleApp.Views.UserCard extends Backbone.View
  template: JST['contact_manager/user_card']
  id: 'contact-card'
    
  events:
    'click #contact-user-ripple': 'sendRequest'
    'click #contact-user-add': 'addContact'

  initialize: ->
    console.log(@model)
    @current_user = @options.current_user
    @target_user = @options.target_user
    console.log(@current_user)
    console.log(@target_user)
    
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    @outputMap()
    
    @updateSocialLinks()
    
    return this
    
  outputMap: ->
    c = new RippleApp.Collections.Addresses(@model.get("addresses"))
    if c.length == 0
      coll = new RippleApp.Collections.Addresses()
      collection = coll
    else
      collection = @model.get("addresses")
    
    map = new RippleApp.Views.ContactCardMap(
      collection: collection
    )
    $('#contact-card-map', @el).append(map.render().el)
    
  addContact: ->
    console.log('Add Contact')
    console.log(@model.attributes)
    name = @model.get('name')
    id = @model.get('_id')
    facebook_id = @model.get('facebook_id')
    twitter_id = @model.get('twitter_id')
    linkedin_id = @model.get('linkedin_id')
    facebook_picture = @model.get('facebook_picture')
    twitter_picture = @model.get('twitter_picture')
    linkedin_picture = @model.get('linkedin_picture')
    contact = new RippleApp.Models.Contact()
    #contact.set(@model.attributes)
    #contact.set(ripple_id: id)
    #contact.save()
    console.log(contact)
    
    contact.set(
      name: name, 
      ripple_id: id,
      facebook_id: facebook_id,
      twitter_id: twitter_id,
      linkedin_id: linkedin_id,
      facebook_picture: facebook_picture,
      twitter_picture: twitter_picture,
      linkedin_picture: linkedin_picture
    )
    
    contact.save(null, success: (r) ->
      console.log(r)
      id = r.get('_id')
      Backbone.history.navigate('contacts/show/' + id, true)
    )
    
    #RippleApp.contactsRouter.contacts.add(contact)
    
    
  sendRequest: ->
    console.log(@model)
    @notification = new RippleApp.Models.Notification()
    console.log(@current_user.get('_id'))
    console.log(@target_user.get('_id'))
    user_id = @target_user.get('_id') 
    @notification.set(
      _type: 'NotificationRipple'
      user_id: user_id
    )
    console.log(@notification)
    @notification.save()
    
  updateSocialLinks: ()=>
    facebook_id = @model.get('facebook_id')
    if facebook_id
      $('#social-network-links a.dicon-facebook', @el).removeAttr('style').removeAttr('data-toggle').attr('href', 'http://www.facebook.com/'+facebook_id).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('facebookSearch')
      this.$('.dicon-facebook').removeClass('social-grey')
      this.$('.dicon-facebook').addClass('social-facebook')
    else
      $('#social-network-links a.facebook', @el).attr('data-toggle', 'modal').attr('style', 'background-color:#CFCFCF;')
      
    if @model.get('twitter_id')
      $('#social-network-links a.dicon-twitter', @el).removeAttr('style').removeAttr('data-toggle').attr('href', 'http://www.twitter.com/'+@model.get('twitter_id')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('twitterSearch')
      this.$('.dicon-twitter').removeClass('social-grey')
      this.$('.dicon-twitter').addClass('social-twitter')
    else
      $('#social-network-links a.twitter', @el).attr('style', 'background-color:#CFCFCF;')
      
    if @model.get('linkedin_id')
      $('#social-network-links a.dicon-linkedin', @el).removeAttr('style').removeAttr('data-toggle').attr('href', @model.get('linkedin_id')).attr('target', '_blank')
      this.$('div.searchIcon').removeClass('linkedinSearch')
      this.$('.dicon-linkedin').removeClass('social-grey')
      this.$('.dicon-linkedin').addClass('social-linkedin')
    else
      $('#social-network-links a.linkedin', @el).attr('style', 'background-color:#CFCFCF;')