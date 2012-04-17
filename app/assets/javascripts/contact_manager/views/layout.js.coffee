class RippleApp.Views.Layout extends Backbone.View
  id: 'view-layout'
  template: JST['contact_manager/layout']

  initialize: ->
    that = @
    $(window).resize(->
      that.fitPanesToWindow()
    )

  render: ->
    $(@el).html(@template())
    sidebarView = new RippleApp.Views.Sidebar()
    $('#view-sidebar', @el).html(sidebarView.render().el)
    @

  setContextView: (view) ->
    $('#view-context', @el).html(view.render().el)
    @fitPanesToWindow()

  setMainView: (view) ->
    $('#view-main', @el).html(view.render().el)
    @fitPanesToWindow()

  fitPanesToWindow: ->
    layoutHeight = $(window).height() - $('.navbar').height()
    @$el.height(layoutHeight)

    mainMargin = $('#view-main').outerWidth() - $('#view-main').innerWidth()

    mainWidth = $(window).innerWidth() - $('#view-sidebar', @el).width() - $('#view-context', @el).width() - mainMargin
    console.log(mainWidth)
    $('#view-main', @el).width(mainWidth)
