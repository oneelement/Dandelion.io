class RippleApp.Views.SettingsSocial extends Backbone.View
  template: JST['contact_manager/settings/settings_social']
  id: 'settings-social'
  
  
  render: ->
    $(@el).html(@template())
    this.$('#settings-social-container').html('')
    view = new RippleApp.Views.SettingsSocialFacebook(
    )
    this.$('#settings-social-container').append(view.render().el)
    view = new RippleApp.Views.SettingsSocialTwitter(
    )
    this.$('#settings-social-container').append(view.render().el)
    view = new RippleApp.Views.SettingsSocialLinkedin(
    )
    this.$('#settings-social-container').append(view.render().el)
    
    return @
    