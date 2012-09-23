class RippleApp.Views.SettingsSocialTwitter extends Backbone.View
  template: JST['contact_manager/settings/settings_social_item']
  id: 'settings-social-twitter'
  className: 'activatable'
  
  events:
    'click .settings-social-import-all': 'activateTwitter' 

    
      
  initialize: ->    
    @current_user = RippleApp.contactsRouter.currentUser
    @contacts = RippleApp.contactsRouter.contacts
    @contacts.on('reset add remove destroy', @render, this)
    @current_user.on('change', @render, this)    
    

  render: ->
    $(@el).html(@template(social: 'twitter'))
    c = @current_user.get('authentications')
    if c.where(provider: "twitter").length > 0
      @checkConnections()  

      
    return @
    
  checkConnections: ->
    id = @current_user.get('contact_id')
    @user_contact = @contacts.get(id)
    twitterImage = '<img src="' + @user_contact.get('twitter_picture') + '"></img>'
    twitterHandle = '<p><a target="_blank" href="' + @user_contact.get('twitter_handle') + '">@' + @user_contact.get('twitter_id') + '</a></p>'
    this.$('a').removeAttr('title').removeAttr('rel').removeAttr('href')
    $(this.el).addClass('connected')
    $(this.el).removeClass('activatable')
    this.$('.settings-social-connected span').addClass('dicon-checkmark')
    this.$('.settings-social-connected span').removeClass('dicon-cancel-2')
    this.$('.settings-social-avatar').html(twitterImage)
    this.$('.settings-social-name').html(twitterHandle)  
    

    
  activateTwitter: =>
    this.$('.settings-social-importing').css('display', 'block')
    console.log('Activate')
    $.get '/imports/import_twitter', (data) =>
      @import_count = data
      @contacts.fetch(success: (response) =>        
        this.$('.settings-social-importing').css('display', 'none')
        $('#global-flashes').css('display', 'block')
        flash = "<p class='content'><span class='dicon-info'></span>" + @import_count + " twitter contacts have been imported.</p>"
        $('#flash-content').html(flash)
      )

    



