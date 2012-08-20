class RippleApp.Views.PictureTimeline extends Backbone.View
  template: JST['contact_manager/picture_timeline']
  tagName: 'ul'
  id: 'picture-timeline'
    
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->    
    $(@el).html(@template())
    @collection.each(@appendTimeline) 
    
    
    
    this    
  
  appendTimeline: (entry) =>
    view = new RippleApp.Views.PictureTimelineEntry(model: entry)
    $(this.el).append(view.render().el)