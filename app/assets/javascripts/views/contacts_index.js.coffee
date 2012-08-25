class RippleApp.Views.ContactsIndex extends Backbone.View
  template: JST['contact_manager/contact_index']
  id: 'contacts-index'
 

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('remove', @render, this)
    @collection.on('destroy', @render, this)
    @mergers = new RippleApp.Collections.Contacts()

  render: ->
    $(@el).html(@template())
    @collection.each(@appendContact)
    this.$('#contacts-table').dataTable("bPaginate": false, "oLanguage": {sSearch: ""}, "bInfo": false, "aaSorting": [ [3,'asc'] ])
    return this
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact, mergers: @mergers)
    #@$el.append(view.render().el)
    this.$('#contacts-table-body').append(view.render().el)
