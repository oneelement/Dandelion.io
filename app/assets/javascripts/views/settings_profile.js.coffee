class RippleApp.Views.SettingsProfile extends Backbone.View
  template: JST['contact_manager/settings/settings_profile']
  id: 'settings-profile'
  
  events:
    'keypress #social-profile-first-name-input, #social-profile-last-name-input, #social-profile-email-input, #social-profile-password-input': 'checkEnter'
  
  initialize: ->    
    @current_user = RippleApp.contactsRouter.currentUser
    @user_contact_id = @current_user.get('contact_id')
    @user_contact = RippleApp.contactsRouter.contacts.get(@user_contact_id)

  render: ->
    $(@el).html(@template(user: @current_user.toJSON()))
    
    return @
    
    
  checkEnter: (event) ->
    console.log(event)
    console.log(event.target.id)
    if (event.keyCode == 13) 
      #event.preventDefault()
      console.log(event.target)
      if event.target.id == 'social-profile-password-input'
        @savePassword()
      else
        @saveUser()
    
  saveUser: ->
    @current_user.set(
      first_name: this.$('input#social-profile-first-name-input').val(),
      last_name: this.$('input#social-profile-last-name-input').val(),
      email: this.$('input#social-profile-email-input').val(), { silent: true }    
    )
    @current_user.save()
    
  savePassword: ->
    @current_user.save(password: this.$('input#social-profile-password-input').val())



