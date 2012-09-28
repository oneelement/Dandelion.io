class RippleApp.Views.SettingsSocialLinkedin extends Backbone.View
  template: JST['contact_manager/settings/settings_social_item']
  id: 'settings-social-linkedin'
  className: 'activatable'
  
  events:
    'click .settings-social-import-all': 'activateLinkedin' 
  
  initialize: ->    
    @current_user = RippleApp.contactsRouter.currentUser
    @contacts = RippleApp.contactsRouter.contacts
    @contacts.on('reset add remove destroy', @render, this)
    @current_user.on('change', @render, this)    
    

  render: ->
    $(@el).html(@template(social: 'linkedin'))
    c = @current_user.get('authentications')
    if c.where(provider: "linkedin").length > 0
      @checkConnections()  
      
    return @
    
  checkConnections: ->
    id = @current_user.get('contact_id')
    @user_contact = @contacts.get(id)
    linkedinImage = '<img src="' + @user_contact.get('linkedin_picture') + '"></img>'
    linkedinHandle = '<p><a target="_blank" href="' + @user_contact.get('linkedin_handle') + '">' + @user_contact.get('name') + '</a></p>'
    this.$('a').removeAttr('title').removeAttr('rel').removeAttr('href')
    $(this.el).addClass('connected')
    $(this.el).removeClass('activatable')
    this.$('.settings-social-connected span').addClass('dicon-checkmark')
    this.$('.settings-social-connected span').removeClass('dicon-cancel-2')
    if @user_contact.get('linkedin_picture')
      this.$('.settings-social-avatar').html(linkedinImage)
    this.$('.settings-social-name').html(linkedinHandle) 
    
  activateLinkedin: =>
    this.$('.settings-social-importing').css('display', 'block')
    console.log('Activate')
    #response = { "isMobile": "true", "provider": "facebook", "authResponse":{"accessToken":"AAADrdwPPB6EBAGwfzDDjz0tMJBhNTFhFy3VdfAc6nAnLPJZCbuswZBguggnA4JoknjI8oEuMGUpT5XmLcI5gEW2JM0A2tXSeZBijd0ZC4AZDZD","session_key":true,"expiresIn":"1353957710711","userId":"628485144","sig":"...","expirationTime":1355306489069966}}
    #$.ajax
    #  type: 'POST'
    #  url: '/authentications/mobile_create'
    #  data: response
    #  dataType: 'json'
    #  #timeout: 300
    #  context: $('body')
    #  success: (data) =>
    #    console.log(JSON.stringify(data))
    #    console.log('success')

    $.get '/imports/import_linkedin', (data) =>
      @import_count = data
      @contacts.fetch(success: (response) =>        
        this.$('.settings-social-importing').css('display', 'none')
        $('#global-flashes').css('display', 'block')
        flash = "<p class='content'><span class='dicon-info'></span>" + @import_count + " linkedIn contacts have been imported.</p>"
        $('#flash-content').html(flash)
      )



