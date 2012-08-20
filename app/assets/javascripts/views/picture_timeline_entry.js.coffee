class RippleApp.Views.PictureTimelineEntry extends Backbone.View
  #templateTwitter: JST['contact_manager/timeline_entry_twitter']
  template: JST['contact_manager/picture_timeline_entry']
  tagName: 'li'
  className: 'picture-timeline-entry'
  

  render: ->    
    $(@el).html(@template(entry: @model.toJSON()))       
    @setUrl()
    @setSourceImage()
    
    return this
    
    
  setUrl: ->
    #html = "<a target='_blank' href='" + @model.get('link') + "'><div class='timeline-entry-picture'></div></a>"
    url = "url('" + @model.get('image_source') + "')"
    #this.$('.timeline-entry-media').html(html)
    #this.$('.timeline-entry-picture').css('background-image', url)
    this.$('.image').css('background-image', url)
    
  setSourceImage: ->
    if @model.get('source') == 'facebook'
      this.$('.image-source').addClass('dicon-facebook')
    else if @model.get('source') == 'twitter'
      this.$('.image-source').addClass('dicon-twitter')

    
    



