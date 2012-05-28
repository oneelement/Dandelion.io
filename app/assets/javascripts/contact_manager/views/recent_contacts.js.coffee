class RippleApp.Views.RecentContacts extends Backbone.View
  template: JST['contact_manager/recent_contacts']
  
  initialize: ->
    @collection.on('add remove reset', @render, @)
  
  render: ->
    $(@el).html(@template())
    $('#recent-contacts-list', @el).empty()
    models = @collection.getTop5()
    models.reverse()
    _.each(models, (model) =>
      if model.id
        $('#recent-contacts-list', @el).append(
          new RippleApp.Views.ContactBadge(model: model).render().el
        )
    )
    @
