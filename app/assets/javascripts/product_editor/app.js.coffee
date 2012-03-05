window.ProductEditor =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    @app = new ProductEditor.Models.ProductEditorApp()

    @view = new ProductEditor.Views.AppView(@app)
    @view.render()

$(document).ready ->
  ProductEditor.init()
