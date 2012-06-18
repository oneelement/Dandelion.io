class RippleApp.Models.ContactAddressDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/addresses'

  getViewIcon: ->
    type = @get("_type")

    if type == 'AddressHome'
      return 'house'
    else if type == 'AddressBusiness'
      return 'building-dark'
    else
      return 'contact'
      
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
