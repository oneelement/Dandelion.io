class ContactManager.Views.ContactsTree extends Backbone.View
  template: JST['contact_manager/contact_tree']
  className: 'contact-tree'
  
  initialize: ->
    @collection.on('add remove reset', @render, @)
  
  render: ->
    $(@el).html(@template())
    _.each(@collection.models, (model) ->
      $('#contacts-tree-list', @el).append(
        new ContactManager.Views.ContactsTreeEntry(model: model).render().el
      ))
    this
