class RippleApp.Views.FavouriteContacts extends Backbone.View

  initialize: ->
    @collection.on('add remove reset', @render, @)
  
  render: ->
    $(@el).empty()
    _.each(@collection.models, (model) =>
      if model.id
        $(@el).append(
          new RippleApp.Views.ContactBadge(model: model).render().el
        )
    )
    @