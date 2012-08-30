class RippleApp.Views.GroupShow extends Backbone.View
  template: JST['contact_manager/groups/group_show']
  className: 'group-show'
  
  events:
    'click #group-contacts, #group-social': 'toggleTab'
  
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
    @sortedCollection = @collection.byName()
    @sortedCollection.each(@appendContact)
    @populateSocial()
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
    this.$('div').removeClass('active')
    $(target, @el).addClass('active')
    if targetId == "group-contacts"
      this.$('#group-social-wrapper').addClass('disabled')
      this.$('#group-contacts-wrapper').removeClass('disabled')
      this.$('#group-header').css('background', '')
    if targetId == "group-social"
      this.$('#group-contacts-wrapper').addClass('disabled')
      this.$('#group-social-wrapper').removeClass('disabled')
      this.$('#group-header').css('background', '#f0f0f0')
      
  populateSocial: ->    
    view = new RippleApp.Views.SocialFeeds(
      model: @model,
      user: @user,
      source: 'group'
    )
    this.$('#group-social-wrapper', @el).html(view.render().el)

    
  autocomplete: =>
    auto = this.$('#groups').autocomplete
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
    contact_group_ids = contact.get('group_ids')
    group_id = @model.get('_id')
    contact_group_ids.push(group_id)
    unique = _.uniq(contact_group_ids)
    contact.set('group_ids', unique, { silent: true })
    contact.save(null, { silent: true })
    this.$('#groups').val("")
    
  appendContact: (contact) =>
    view = new RippleApp.Views.ContactsList(model: contact, source: 'group_show', selected: '')
    #@$el.append(view.render().el)
    this.$('#contacts-table-body').append(view.render().el)


