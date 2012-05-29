class RippleApp.Views.ContactsList extends Backbone.View
  template: JST['contact_manager/contact_list']
  tagName: 'tr'
  className: 'contact-list-item'
  
  initialize: ->
    @model.on('change', @render, this)
  
  events:
    'click .contact-list-detail': 'previewContact'
    'click .close': 'destroyContact'
    'click #open-action': 'openContact'
    

  render: ->
    $(@el).html(@template(contact: @model.toJSON()))    
    @getSections()    
    return this
    
  getSections: =>
    viewPhone = new RippleApp.Views.ContactListSection(collection: @model.get('phones'))
    this.$('.phone-details').append(viewPhone.render().el)    
    viewEmail = new RippleApp.Views.ContactListSection(collection: @model.get('emails'))
    this.$('.email-details').append(viewEmail.render().el)
  
  previewContact: (event) ->
    Backbone.history.navigate('#contacts/preview/' + @model.id, true)
      
  destroyContact: ->
    getrid = confirm "Are you sure you want to delete this contact?"
    if getrid == true
      this.model.destroy()
      $("#contact-container").html('')

  openContact: ->
    Backbone.history.navigate('#contacts/show/'+ @model.id, true)
