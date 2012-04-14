class RippleApp.Views.ContactsList extends Backbone.View
  template: JST['contact_manager/contact_list']
  className: 'contact-list-item'
  
  initialize: ->
    @model.on('change', @render, this)
  
  events:
    'click': 'activeContact'
    'click .close': 'destroyContact'
    

  render: ->
    this.model.addresses = new RippleApp.Collections.Contacts(this.model.get('addresses'))
    this.model.phones = new RippleApp.Collections.Contacts(this.model.get('phones'))
    #this.model.phones = new RippleApp.Collections.Phones(this.model.get('phones'))
    #this.model.address = new RippleApp.Models.Address(this.model.get('address'))
    #myphones = this.model.get("phones")
    $(@el).html(@template(contact: @model))
    return this
  
  activeContact: (event) ->
    view = new RippleApp.Views.Contact(model: @model)
    RippleApp.layout.setContextView(view)

    if ($(this.el).hasClass('active'))
    else
      $(".contact-list-items").removeClass('active')
      $("#contact-container").html('')
      $(this.el).addClass('active')
      view = new RippleApp.Views.Contact(model: @model)
      $('#contact-container').append(view.render().el)
      
  destroyContact: ->
    getrid = confirm "Are you sure you want to delete this contact?"
    if getrid == true
      this.model.destroy()
      $("#contact-container").html('')
