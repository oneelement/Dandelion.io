class RippleApp.Views.Timeline extends Backbone.View
  template: JST['contact_manager/timeline']
  tagName: 'ul'
  id: 'timeline'
    
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->    
    $(@el).html(@template())
    @collection.each(@appendTimeline) 
    #console.log('2')
    #console.log(@collection)
    console.log('render timeline')
    
    this    
  
  appendTimeline: (entry) =>
    view = new RippleApp.Views.TimelineEntry(model: entry)
    $(this.el).append(view.render().el)