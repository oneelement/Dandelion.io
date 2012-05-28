class RippleApp.Views.FavouriteContacts extends Backbone.View

  initialize: ->
    #added to re-render when a new favorite is added to the collection. OC 28/05
    @collection.on('add remove reset', @render, @)
  
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

  #events:
    #this will not work as there is no model.  I presume this is a mistake OC 28/05
    #"click": "clicked"

  #clicked: ->
    #this will not work as there is no model.  I presume this is a mistake OC 28/05
    #Backbone.history.navigate('contacts/show/' + @model.id, true)
