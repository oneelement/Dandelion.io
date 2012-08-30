class RippleApp.Views.ContactsIndex extends Backbone.View
  template: JST['contact_manager/contact_index']
  id: 'contacts-index'
  
  events:
    'click #delete-contact': 'deleteContact'


  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('remove', @render, this)
    #@collection.on('destroy', @render, this)
    @mergers = new RippleApp.Collections.Contacts()
    @selected = new RippleApp.Collections.Contacts()
    @selected.on('add', @selectedContact, this)
    @selected.on('remove', @selectedContact, this)
    @favouriteContacts = RippleApp.contactsRouter.favouriteContacts 
    @recentContacts = RippleApp.contactsRouter.recentContacts
    @currentUser = RippleApp.contactsRouter.currentUser
    @source = @options.source

  render: ->
    $(@el).html(@template())
    @collection.each(@appendContact)
    this.$('#contacts-table').dataTable("bPaginate": false,  "oLanguage": {sSearch: ""}, "bInfo": false, "aaSorting": [ [3,'asc'] ])
    html = "<div id='action-wrapper'></div>"
    this.$('#contacts-table_filter').append(html)
    
    return this
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact, selected: @selected)
    #@$el.append(view.render().el)
    this.$('#contacts-table-body').append(view.render().el)
    
  selectedContact: ->
    console.log('worky worky')
    console.log(@selected)
    if @selected.length > 0
      html = "<span id='delete-contact' class='button button-delete'>delete</span>"
      this.$('#action-wrapper').html(html)
    else
      html = ""
      this.$('#action-wrapper').html(html)
      
  deleteContact: ->
    if @source == 'contact'
      you_sure = confirm("Are you sure you wish to delete contact(s)")
      if you_sure == true
        ids = @selected.pluck('_id')
        #sent = JSON.stringify(ids)
        sent = "sent=" + ids
        $.ajax '/contacts/multipledelete', 
          type: 'GET'
          data: sent
          success: (data) =>
            @collection.remove(@selected.models)
            @favouriteContacts.remove(@selected.models)
            @recentContacts.remove(@selected.models)
            @selected.reset()
            @currentUser.set('favourite_contacts', JSON.stringify(@favouriteContacts))
            @currentUser.set('recent_contacts', JSON.stringify(@recentContacts))
            @currentUser.save()
        Backbone.history.navigate('#contacts', true)
    if @source == 'group'
      you_sure = confirm("Are you sure you wish to delete group(s)")
      if you_sure == true
        ids = @selected.pluck('_id')
        #sent = JSON.stringify(ids)
        sent = "sent=" + ids
        $.ajax '/groups/multipledelete', 
          type: 'GET'
          data: sent
          success: (data) =>
            @collection.remove(@selected.models)
            @favouriteContacts.remove(@selected.models)
            @recentContacts.remove(@selected.models)
            @selected.reset()
            @currentUser.set('favourite_contacts', JSON.stringify(@favouriteContacts))
            @currentUser.set('recent_contacts', JSON.stringify(@recentContacts))
            @currentUser.save()
        Backbone.history.navigate('#groups', true)
      

    
