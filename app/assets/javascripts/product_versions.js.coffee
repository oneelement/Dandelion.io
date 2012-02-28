$(document).ready(->
    window.ProductVersions = new Onelement.Routers.ProductVersions()
    Backbone.history.start()
    ProductVersions.navigate('', {trigger: true})

    $('#action-save').click(->
      ProductVersions.version.save())
)
