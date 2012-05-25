class RippleApp.Views.GroupShow extends Backbone.View
  template: JST['contact_manager/groups/group_show']
  className: 'group-show'
  
  events:
    'click #group-contacts, #group-blank': 'toggleTab'
  
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
    
  toggleTab: (event) ->
    target = event.target
    targetId = event.target.id
    this.$('li').removeClass('active')
    $(target, @el).addClass('active')
    if targetId == "group-contacts"
      this.$('#group-blank-wrapper').addClass('disabled')
      this.$('#group-contacts-wrapper').removeClass('disabled')
    if targetId == "group-blank"
      this.$('#group-contacts-wrapper').addClass('disabled')
      this.$('#group-blank-wrapper').removeClass('disabled')
    
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
    @collection.add(contact)
    this.$('#groups').val("")
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact)
    #@$el.append(view.render().el)
    this.$('#contacts-table-body').append(view.render().el)


