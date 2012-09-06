class RippleApp.Views.PictureTimeline extends Backbone.View
  template: JST['contact_manager/picture_timeline']
  tagName: 'ul'
  id: 'picture-timeline'
  className: 'jcarousel-skin-tango'
    
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->    
    $(@el).html(@template())
    @collection.each(@appendTimeline) 
    
    @addDummyEntry()
    
    
    
    this    
  
  appendTimeline: (entry) =>
    view = new RippleApp.Views.PictureTimelineEntry(model: entry)
    $(this.el).append(view.render().el)
    
  addDummyEntry: ->
    #fixes plugin, hiding when only 1 picture in timeline
    html = "<li class='dummy-entry picture-timeline-entry'></li>"
    $(this.el).append(html)
    if @collection.length == 0
      html = "<li class='info-entry picture-timeline-entry'><span class='dicon-info'></span><span>No pictures are available</span></li>"
      $(this.el).append(html)
      html = "<li class='info-entry picture-timeline-entry'></li>"
      $(this.el).append(html)
