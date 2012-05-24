class RippleApp.Views.GroupShow extends Backbone.View
  template: JST['contact_manager/groups/group_show']
  className: 'group-show'
  
  initialize: ->
    @model.on('change', @render, this)
    @user = @options.user
    @contactIds = @model.get('contact_ids')
    @contacts = RippleApp.contactsRouter.contacts
    @collection = new RippleApp.Collections.Contacts()
    @fillCollection() #tried this in the router but it was slow, this way seems much snappier, OC
    @collection.on('reset add destroy', @render, this)

  render: ->
    $(@el).html(@template(group: @model.toJSON())) 
    @autocomplete()
    @collection.each(@appendContact)
    return this
    
  fillCollection: ->
    _.each(this.model.get('contact_ids'), (contact_id) =>
      contact = @contacts.get(contact_id)
      console.log(contact)
      @collection.add(contact)
    )
    
  autocomplete: =>
    this.$('#groups').autocomplete
      source: "autocomplete/contacts"
      delay: 100      
      minLength: 2
      select: (event, ui) =>
        @addGroupContact(event, ui)
        
  addGroupContact: (event, ui) =>
    @contactIds.push(ui.item.id)
    unique = _.uniq(@contactIds)
    @model.set('contact_ids', unique)
    @model.save()
    #contacts = RippleApp.contactsRouter.contacts
    contact = @contacts.get(ui.item.id)
    console.log(@contacts)
    console.log(contact)
    @collection.add(contact)
    console.log(@collection)
    this.$('#groups').val("")
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact)
    #@$el.append(view.render().el)
    this.$('#contacts-table-body').append(view.render().el)


