class RippleApp.Views.SettingsSocialFacebook extends Backbone.View
  template: JST['contact_manager/settings/settings_social_item']
  id: 'settings-social-facebook'
  className: 'activatable'
  
  events:
    'click .connected .settings-social-import-all': 'activateFacebok'
  
  initialize: ->    
    @current_user = RippleApp.contactsRouter.currentUser
    @contacts = RippleApp.contactsRouter.contacts
    @contacts.on('reset add remove destroy', @render, this)
    @current_user.on('change', @render, this)    
    

  render: ->
    $(@el).html(@template(social: 'facebook'))
    c = @current_user.get('authentications')
    if c.where(provider: "facebook").length > 0
      @checkConnections()   
    
    return @
    
  checkConnections: ->
    id = @current_user.get('contact_id')
    @user_contact = @contacts.get(id)
    facebookImage = '<img src="' + @user_contact.get('facebook_picture') + '"></img>'
    facebookHandle = '<p><a target="_blank" href="' + @user_contact.get('facebook_handle') + '">' + @user_contact.get('name') + '</a></p>'
    console.log(@user_contact.get('facebook_picture'))
    this.$('a').removeAttr('title').removeAttr('rel').removeAttr('href')
    $(this.el).addClass('connected')
    $(this.el).removeClass('activatable')
    this.$('.settings-social-connected span').addClass('dicon-checkmark')
    this.$('.settings-social-connected span').removeClass('dicon-cancel-2')
    this.$('.settings-social-avatar').html(facebookImage)
    this.$('.settings-social-name').html(facebookHandle)

    
  activateFacebok: ->
    console.log('Activate')
    #username = $(this).val()
    #callback = (response) -> markerUsername response
    $.get '/imports/import_facebook', (data) ->
      console.log('Facebook Contacts Imported')

    



