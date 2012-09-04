class RippleApp.Models.ContactAddressDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/addresses'

  getViewIcon: ->
    type = @get("_type")

    if type == 'AddressPersonal'
      return 'location'
    else if type == 'AddressBusiness'
      return 'office'
    else
      return 'location'
      
  getTypes: ->
    #types = ['AddressHome', 'AddressBusiness', 'Address']
    types = [{icon: 'location', type: 'AddressPersonal', text: 'Home Address'}, {icon: 'office', type: 'AddressBusiness', text: 'Business Address'}]
    return types   

  getViewValue: ->
    return @get("full_address")
    
  getFieldName: ->
    return "full_address"
    
  getModelType: ->
    return "address"
    
  defaultType: ->
    return "AddressPersonal"
