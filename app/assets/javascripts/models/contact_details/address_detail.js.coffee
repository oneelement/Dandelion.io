class RippleApp.Models.ContactAddressDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/addresses'

  getViewIcon: ->
    type = @get("_type")

    if type == 'AddressHome'
      return 'book'
    else if type == 'AddressBusiness'
      return 'book'
    else
      return 'book'
      
  getTypes: ->
    #types = ['AddressHome', 'AddressBusiness', 'Address']
    types = [{icon: 'AH', type: 'AddressHome'}, {icon: 'AB', type: 'AddressBusiness'}, {icon: 'AD', type: 'Address'}]
    return types   

  getViewValue: ->
    return @get("full_address")
    
  getFieldName: ->
    return "full_address"
    
  getModelType: ->
    return "address"
