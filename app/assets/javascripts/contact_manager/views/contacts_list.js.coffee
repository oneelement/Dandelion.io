class RippleApp.Views.ContactsList extends Backbone.View
  template: JST['contact_manager/contact_list']
  className: 'contact-list-item'
  
  initialize: ->
    @model.on('change', @render, this)
  
  events:
    'click': 'previewContact'
    'click .close': 'destroyContact'
    'click #open-action': 'openContact'
    

  render: ->
    this.model.addresses = new RippleApp.Collections.Contacts(this.model.get('addresses'))
    this.model.phones = new RippleApp.Collections.Contacts(this.model.get('phones'))
    $(@el).html(@template(contact: @model))
    return this
  
  previewContact: (event) ->
    Backbone.history.navigate('#contacts/preview/' + @model.id, true)
      
  destroyContact: ->
    getrid = confirm "Are you sure you want to delete this contact?"
    if getrid == true
      this.model.destroy()
      $("#contact-container").html('')

  openContact: ->
    Backbone.history.navigate('#contacts/show/'+ @model.id, true)
