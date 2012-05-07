class RippleApp.Models.ContactAddressDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    type = @get("_type")

    if type == 'AddressHome'
      return 'house'
    else if type == 'AddressBusiness'
      return 'building-dark'
    else
      return 'contact'

  getViewValue: ->
    return @get("full_address")
