class RippleApp.Views.SettingsSocialGoogle extends Backbone.View
  template: JST['contact_manager/settings/settings_social_item']
  id: 'settings-social-google'
  className: 'activatable'
  
  events:
    'click .settings-social-import-all': 'activateGoogle' 

    
      
  initialize: ->    
    @current_user = RippleApp.contactsRouter.currentUser
    @contacts = RippleApp.contactsRouter.contacts
    @contacts.on('reset add remove destroy', @render, this)
    @current_user.on('change', @render, this)    
    

  render: ->
    $(@el).html(@template(social: 'google'))
    c = @current_user.get('authentications')
    if c.where(provider: "google_oauth2").length > 0
      @checkConnections()  

      
    return @
    
  checkConnections: ->
    id = @current_user.get('contact_id')
    @user_contact = @contacts.get(id)
    googleImage = '<img src="' + @user_contact.get('google_picture') + '"></img>'
    googleHandle = '<p><a target="_blank" href="' + @user_contact.get('google_handle') + '">' + @user_contact.get('name') + '</a></p>'
    this.$('a').removeAttr('title').removeAttr('rel').removeAttr('href')
    $(this.el).addClass('connected')
    $(this.el).removeClass('activatable')
    this.$('.settings-social-connected span').addClass('dicon-checkmark')
    this.$('.settings-social-connected span').removeClass('dicon-cancel-2')
    if @user_contact.get('google_picture')
      this.$('.settings-social-avatar').html(googleImage)    
    this.$('.settings-social-name').html(googleHandle)  
    

    
  activateGoogle: =>
    this.$('.settings-social-importing').css('display', 'block')
    console.log('Activate')
    $.get '/imports/import_google', (data) =>
      console.log('Imported Google contacts')
      @import_count = data
      @contacts.fetch(success: (response) =>        
        this.$('.settings-social-importing').css('display', 'none')
        $('#global-flashes').css('display', 'block')
        flash = "<p class='content'><span class='dicon-info'></span>" + @import_count + " gmail contacts have been imported.</p>"
        $('#flash-content').html(flash)
      )

    



