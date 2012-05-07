class RippleApp.Models.ContactPhoneDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    type = @get("_type")

    if type == 'PhoneHome'
      return 'house'
    else if type == 'PhoneBusiness'
      return 'building-dark'
    else if type == 'PhoneMobile'
      return 'mobile'
    else
      return 'phone'
    

  getViewValue: ->
    return @get("number")
