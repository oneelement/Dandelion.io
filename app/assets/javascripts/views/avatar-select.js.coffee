class RippleApp.Views.AvatarSelect extends Backbone.View
  template: JST['contact_manager/avatar-select']
  tagName: 'li'
  className: 'avatar'
  
  events:
    'click img': 'setAvatar'
    
  initialize: ->
    #@model.on('change', @render, this)
    @url = @options.url
    @social = @options.social

  render: ->    
    $(@el).html(@template(url: @url, social: @social, avatar: @model.toJSON()))
    
    if @social == 'linkedin'
      this.$('.social-icon').addClass('dicon-linkedin')
    else if @social == 'facebook'
      this.$('.social-icon').addClass('dicon-facebook')
    else if @social == 'twitter'
      this.$('.social-icon').addClass('dicon-twitter')
    
    
    return this
    
  setAvatar: (e) =>
    console.log(e.target)
    console.log(e)
    @model.set('avatar', @url)
    @model.unset('hashtags', { silent: true })
    @model.save()
    $('#avatar-modal').modal('hide')
    
    
    


