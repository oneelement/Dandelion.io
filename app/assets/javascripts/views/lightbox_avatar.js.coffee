class RippleApp.Views.LightboxAvatar extends Backbone.View
  template: JST['contact_manager/picture_modal']
  id: 'avatar-lightbox'
  

  render: ->   
    $(@el).html(@template(contact: @model.toJSON())) 
    
    @setAvatars()
    
    return this
    
  setAvatars: ->
    this.$('#avatar-list').html('')
    $('#expanded-map').css('display','none')
    if @model.get('linkedin_picture')
      console.log(@model.get('linkedin_id'))
      url = @model.get('linkedin_picture')      
      view = new RippleApp.Views.AvatarSelect(url: url, social: 'linkedin', model: @model)
      this.$('#avatar-list').append(view.render().el)
    if @model.get('facebook_picture')
      url = @model.get('facebook_picture')
      view = new RippleApp.Views.AvatarSelect(url: url, social: 'facebook', model: @model)
      this.$('#avatar-list').append(view.render().el)
    if @model.get('twitter_picture')
      url = @model.get('twitter_picture')
      twitter_id = @model.get('twitter_id')
      view = new RippleApp.Views.AvatarSelect(url: url, social: 'twitter', model: @model)
      this.$('#avatar-list').append(view.render().el)

    

    
 