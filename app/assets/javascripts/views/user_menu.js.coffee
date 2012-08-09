class RippleApp.Views.UserMenu extends Backbone.View
  template: JST['contact_manager/user_menu']
  tagName: 'ul'
  id: 'profile-list'
  
  events:
    'click #user-settings': 'openSettings'    

  render: ->
    $(@el).html(@template())
    
    return @
    
  openSettings: ->
    console.log('Open Settings')
    $('#settings-lightbox').addClass('show').addClass('settings')
    $('#settings-lightbox').css('display', 'block')
    $('.lightbox-backdrop').css('display', 'block')


