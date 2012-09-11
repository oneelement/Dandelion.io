class RippleApp.Views.LionSearch extends Backbone.View
  template: JST['contact_manager/lion_search_item']
  tagName: 'li'
  className: 'lion-search'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(lion: @model.toJSON()))
    this


