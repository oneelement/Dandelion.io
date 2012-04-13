class RippleApp.Views.Contact extends Backbone.View
  template: JST['contact_manager/contact_show']
  #className: 'contact-inactive'
  
  #initialize: ->
    #@collection.on('reset', @render, this)
    
  events:
    'click .favorite-ind': 'checkFavorite'
    
  initialize: ->
    @model.on('change', @render, this)

  render: ->
    this.model.addresses = new RippleApp.Collections.Contacts(this.model.get('addresses'))
    this.model.phones = new RippleApp.Collections.Contacts(this.model.get('phones'))
    #this.model.phones = new RippleApp.Collections.Phones(this.model.get('phones'))
    #this.model.address = new RippleApp.Models.Address(this.model.get('address'))
    #myphones = this.model.get("phones")
    $(@el).html(@template(contact: @model))
    return this
    
  checkFavorite: ->
    if ($(this.el).hasClass('favorite'))
      $(this.el).removeClass('favorite')
      currentuser = new RippleApp.Models.Currentuser()
      currentuser.fetch({success: @handleDelete})
      #console.log(this.model.get('favorite_ids'))
      #favorite = new RippleApp.Models.Favorite(favorite_id: this.model.get('_id'))
      #favorite.destroy()
    else
      $(this.el).addClass('favorite')
      currentuser = new RippleApp.Models.Currentuser()
      currentuser.fetch({success: @handleSuccess})
      #console.log(this.model.get('favorite_ids'))

	
  handleSuccess: (currentuser, response) =>
    id = response._id
    #console.log(id)
    #console.log(currentuser)
    #console.log(this.model.get('favorite_ids'))
    user = new 
    this.model.get('favorite_ids').push(id)
    this.model.save()
    
  handleDelete: (currentuser, response) =>
    id = response._id
    console.log(id)
    console.log(currentuser)
    console.log(this.model.get('favorite_ids'))
    included = "test" in this.model.get('favorite_ids')
    console.log(included)
    this.model.get('favorite_ids').pop(id)
    this.model.save()
