class RippleApp.Views.Settings extends Backbone.View
  template: JST['contact_manager/settings/settings']
  id: 'settings-container'
  
  events:
    'click #settings-social-item': 'settingsSocial' 
    'click #settings-profile-item': 'settingsProfile'
  


  render: ->
    $(@el).html(@template())
    @settingsSocial()    
   
    return @
    
  settingsSocial: ->
    this.$('#settings-menu ul li').removeClass('active')
    this.$('#settings-social-item').addClass('active')
    view = new RippleApp.Views.SettingsSocial(
    )
    this.$('#settings-content').html(view.render().el)
    
  settingsProfile: ->
    this.$('#settings-menu ul li').removeClass('active')
    this.$('#settings-profile-item').addClass('active')
    view = new RippleApp.Views.SettingsProfile(
    )
    this.$('#settings-content').html(view.render().el)
    



