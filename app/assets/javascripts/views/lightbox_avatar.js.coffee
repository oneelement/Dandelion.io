class RippleApp.Views.LightboxAvatar extends Backbone.View
  template: JST['contact_manager/picture_modal']
  id: 'avatar-lightbox'
  
  
  render: ->   
    $(@el).html(@template(contact: @model.toJSON())) 
    
    @setAvatars()
    
    options = {
      resetForm: true
      success: (response) =>
        @uploadSuccess(response)
      error: (response) =>
        @uploadError(response)
    }
    
    this.$('#avatar-upload-form').ajaxForm(options)
    
    #@dragDrop()

    
    return this
    
    
  dragDrop: ->
    dropbox = this.$('#avatar-droppable')
    dropbox.filedrop(
      paramname:'avatar[photo]'
      url: '/avatars.json'
      allowedfiletypes: ['image/jpg','image/png','image/gif']
    )

    template = '<div class="preview">' +
               '<span class="imageHolder">'+
               '<img />'+
               '<span class="uploaded"></span>'+
               '</span>'+
               '<div class="progressHolder">'+
               '<div class="progress"></div>'+
               '</div>'+
               '</div>';

  createImage: (file) ->
    preview = $(template)
    image = $('img', preview)
    reader = new FileReader()
    image.width = 100
    image.height = 100
    reader.onload = (e) ->
      image.attr('src',e.target.result)
    reader.readAsDataURL(file)
    message.hide()
    preview.appendTo(dropbox) 
    $.data(file,preview)
    
    
  uploadSuccess: (response) ->
    console.log(response)
    console.log(response.photo.url)
    html = "<img src='" + response.photo.url + "'></img>"
    this.$('#upload-container').append(html)
    if response.photo.url
      $('.lightbox-backdrop').css('display', 'none')
      @model.set('avatar', response.photo.small_thumb.url)
      @model.unset('hashtags', { silent: true })
      @model.save(null, { silent: true })
      
  uploadError: (response) ->
    console.log(response)



    
  setAvatars: ->
    this.$('#avatar-list').html('')
    $('#expanded-map').css('display','none')
    if @model.get('linkedin_picture')
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
      
  closeLightbox: ->
      $('.lightbox').removeClass('show')
      $('.lightbox').removeClass('map')
      $('.lightbox').removeClass('avatar')
      $('.lightbox').removeClass('settings')
      $('.lightbox').css('display', 'none')
      $('.lightbox-backdrop').css('display', 'none')

    

    
 