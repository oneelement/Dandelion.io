class RippleApp.Views.RecentContacts extends Backbone.View
  template: JST['contact_manager/recent_contacts']
  
  initialize: ->
    @collection.on('add remove reset', @render, @)
    console.log(@collection)
  
  render: ->
    $(@el).html(@template())
    _.each(@collection.models, (model) ->
      $('#recent-contacts-list', @el).prepend(
        new RippleApp.Views.RecentContactsEntry(model: model).render().el
      )
    )
    console.log(@collection)
    @
