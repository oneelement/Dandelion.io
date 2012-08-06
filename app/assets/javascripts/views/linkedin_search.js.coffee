class RippleApp.Views.LinkedinSearch extends Backbone.View
  template: JST['contact_manager/linkedin_search_item']
  tagName: 'li'
  className: 'linkedin-search'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->    
    $(@el).html(@template(linkedin: @model.toJSON()))
    this


