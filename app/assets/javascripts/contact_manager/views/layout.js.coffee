class RippleApp.Views.Layout extends Backbone.View
  id: 'view-layout'
  template: JST['contact_manager/layout']

  initialize: ->
    @sidebarView = new RippleApp.Views.Sidebar()
    @contextView = null
    @mainView = null
    that = @
    $(window).resize(->
      that.render())

  render: ->
    @$el.html(@template())
    
    $('#view-sidebar', @el).html(@sidebarView.render().el)
    if @contextView?
      $('#view-context', @el).html(@contextView.render().el)
    if @mainView?
      $('#view-main', @el).html(@mainView.render().el)

    @fitPanesToWindow()
    @

  setContextView: (view) ->
    @contextView = view
    $('#view-context', @el).html(view.render().el)
    @fitPanesToWindow()

  setMainView: (view) ->
    @mainView = view
    $('#view-main', @el).hide()
    $('#view-main', @el).html(view.render().el)
    $('#view-main', @el).slideDown()
    @fitPanesToWindow()

  fitPanesToWindow: ->
    layoutHeight = $(window).height() - $('.navbar').height()
    @$el.height(layoutHeight)

    mainWidth = $(window).innerWidth() - $('#view-sidebar').width() - $('#view-context').width() - 25
    $('#view-main', @el).width(mainWidth)
