class RippleApp.Views.FavouriteContacts extends Backbone.View

  initialize: ->
    @collection.on('add remove reset', @render, @)
  
  render: ->
    $(@el).empty()
    if @collection.length == 0
      html = "<span class='dicon-info'></span>&nbsp;<span>No favorites added.</span>"
      $(@el).append(html)
      $('#favorite-menu .dicon-star').css('color', '#f0f0f0')
    else
      $('#favorite-menu .dicon-star').css('color', '#FFDF00')
      
    _.each(@collection.models, (model) =>
      if model.id
        $(@el).append(
          new RippleApp.Views.ContactBadge(model: model).render().el
        )
    )
    @