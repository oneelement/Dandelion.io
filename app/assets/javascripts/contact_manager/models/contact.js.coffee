class RippleApp.Models.Contact extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: -> '/contacts/'
  
  isUser: ->
    return this.get('is_user') == true
  
  #I think all this code is redundant, it seemed to work ok with ActiveRecord but i've had to add 
  #code to the render function in contacts_show view which makes it work.  A collection is 
  #required though so the phones are not working unless it is moved form being embedded.

  initialize: ->
    #this.user = new Crm.Models.User(this.get('user'))
    #addresses = new RippleApp.Models.Address(this.get('addresses'))
    #this.setAddresses(addresses)
    #phones = new RippleApp.Models.Phone(this.get('phones'))
    #this.setPhones(phones)
    #this.set({favorite_ids: new Array()})
   
  setAddresses: (addresses) ->
    this.addresses = addresses
    
  setPhones: (phones) ->
    this.phones = phones
  

  #relations: [
   # type: 'HasMany'
   # key: 'addresses'
   # relatedModel: 'RippleApp.Models.Address'
   # includeInJSON: true
   # createModels: true
  #]
