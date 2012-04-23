class RippleApp.Models.ContactAddressDetail extends Backbone.RelationalModel

  getViewIcon: ->
    type = @get("type")

    if type == 'Home'
      return 'house'
    else if type == 'Business'
      return 'building-dark'
    else
      return 'contact'

  getViewValue: ->
    return @get("full_address")
