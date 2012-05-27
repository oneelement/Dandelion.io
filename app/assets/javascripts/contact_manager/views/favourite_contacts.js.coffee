class RippleApp.Views.FavouriteContacts extends Backbone.View

  render: ->
    $(@el).append(
        icon = new RippleApp.Models.ContactBadge()
        icon.set("name", "Favourites")
        icon.set("avatar", "http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/32/Places-favorites-icon.png")
        new RippleApp.Views.ContactBadge(model: icon).render().el
      )
    _.each(@collection.models, (model) =>
      $(@el).append(
        new RippleApp.Views.ContactBadge(model: model).render().el
      )
    )
    @

  events:
    "click": "clicked"

  clicked: ->
    Backbone.history.navigate('contacts/show/' + @model.id, true)
