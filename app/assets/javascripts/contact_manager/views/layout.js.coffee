class RippleApp.Views.Layout extends Backbone.View
  id: 'view-layout'
  template: JST['contact_manager/layout']

  render: ->
    $(@el).html(@template())
    sidebarView = new RippleApp.Views.Sidebar()
    $('#view-sidebar', @el).html(sidebarView.render().el)
    @

  setContextView: (view) ->
    $('#view-context', @el).html(view.render().el)

  setMainView: (view) ->
    $('#view-main', @el).html(view.render().el)
