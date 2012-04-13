class RippleApp.Views.Layout extends Backbone.View
  id: 'view-layout'
  template: JST['contact_manager/layout']

  initialize: ->
    @sidebarView = new RippleApp.Views.Sidebar()
    @contextView = null
    @mainView = null

  render: ->
    @$el.html(@template())
    $('#view-sidebar', @el).html(@sidebarView.render().el)
    if @contextView?
      $('#view-context', @el).html(@contextView.render().el)
    if @mainView?
      $('#view-main', @el).html(@mainView.render().el)
    @

  setContextView: (view) ->
    @contextView = view
    $('#view-context', @el).html(view.render().el)

  setMainView: (view) ->
    @mainView = view
    $('#view-main', @el).hide()
    $('#view-main', @el).html(view.render().el)
    $('#view-main', @el).slideDown()
