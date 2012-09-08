class RippleApp.Views.SettingsSocialLinkedin extends Backbone.View
  template: JST['contact_manager/settings/settings_social_item']
  id: 'settings-social-linkedin'
  className: 'activatable'
  
  events:
    'click .connected .settings-social-import-all': 'activateLinkedin' 
  
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
    
  activateLinkedin: ->
    console.log('Activate')
    $.get '/imports/import_linkedin', (data) ->
      console.log('Facebook Contacts Imported')



