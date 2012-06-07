class RippleApp.Views.AvatarSelect extends Backbone.View
  template: JST['contact_manager/avatar-select']
  tagName: 'li'
  className: 'avatar-select'
  
  events:
    'click img': 'setAvatar'
    
  initialize: ->
    #@model.on('change', @render, this)
    @url = @options.url

  render: ->    
    $(@el).html(@template(url: @url, avatar: @model.toJSON()))
    this
    
  setAvatar: (e) =>
    console.log(e.target)
    console.log(e)
    @model.set('avatar', @url)
    @model.unset('hashtags', { silent: true })
    @model.save()
    $('#avatar-modal').modal('hide')
    
    
    


