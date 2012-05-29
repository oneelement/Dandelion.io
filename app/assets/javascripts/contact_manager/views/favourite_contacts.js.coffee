class RippleApp.Views.FavouriteContacts extends Backbone.View

  initialize: ->
    @collection.on('add remove reset', @render, @)
  
  render: ->
    $(@el).empty()
    $(@el).append(
      icon = new RippleApp.Models.ContactBadge()
      icon.set("name", "Favourites")
      icon.set("avatar", "http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/32/Places-favorites-icon.png")
      new RippleApp.Views.ContactBadge(model: icon).render().el
    )
    _.each(@collection.models, (model) =>
      if model.id
        $(@el).append(
          new RippleApp.Views.ContactBadge(model: model).render().el
        )
    )
    @