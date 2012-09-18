class RippleApp.Views.MergeEntry extends Backbone.View
  template: JST['contact_manager/merge_entry']
  tagName: 'tr'
  className: 'contact-list-item'
  
  events:
    'click .select': 'toggleSelect'
  
  initialize: ->
    @model.on('change', @render, this)
    @source = @model.getModelName()
    @selected = @options.selected
    @master = @options.master
    @favouriteContacts = RippleApp.contactsRouter.favouriteContacts 
    @groups = RippleApp.contactsRouter.groups
   
  render: ->
    $(@el).html(@template(contact: @model.toJSON(), modelType: @source))
    @getSections()  
    if @favouriteContacts.get(@model.get("_id"))
      this.$('.dicon-star').addClass('isFavorite')
    if @model.get('facebook_id')
      this.$('.dicon-facebook').addClass('facebook-active')
    if @model.get('twitter_id')
      this.$('.dicon-twitter').addClass('twitter-active')
    if @model.get('linkedin_id')
      this.$('.dicon-linkedin').addClass('linkedin-active')
    
    return this
    
  toggleSelect: =>
    if this.$('.dicon-checkmark').hasClass('select-merge-item')
      this.$('.dicon-checkmark').removeClass('select-merge-item')
      #@selected.remove(@model)
      $('#merge-with-master-contact').removeClass('complete-merge')         
      @master.unset('_id')
      @master_id = @master.get('_id')
      console.log(@master_id)
    else 
      $('#merge-with-master-contact').addClass('complete-merge')
      $('.dicon-checkmark').removeClass('select-merge-item')
      this.$('.dicon-checkmark').addClass('select-merge-item')
      id = @model.get('_id')
      @master.set('_id', id)
      @master_id = @master.get('_id')
      console.log(@master_id)
      console.log(@master)

    
  getSections: ->  
    viewPhone = new RippleApp.Views.ContactListSection(collection: @model.get('phones'), subject: @model)
    this.$('.phone-details').append(viewPhone.render().el)    
    viewEmail = new RippleApp.Views.ContactListSection(collection: @model.get('emails'), subject: @model)
    this.$('.email-details').append(viewEmail.render().el)
    @groupCollection = new RippleApp.Collections.Groups()
    if @model.get('group_ids')
      group_ids = @model.get('group_ids')
      _.each(group_ids, (group_id) =>
        group = @groups.get(group_id)
        if group
          @groupCollection.add(group)
      )
    viewGroup = new RippleApp.Views.ContactListSection(
      title: 'Groups'
      subject: @model
      collection: @model.get('emails')  
      groups: @groupCollection
    )
    this.$('.hashtag-details').append(viewGroup.render().el)