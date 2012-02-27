$(document).ready(->
    window.ProductVersions = new Onelement.Routers.ProductVersions()
    Backbone.history.start()

    ProductVersions.navigate('', {trigger: true})
)
