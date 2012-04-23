class RippleApp.Models.ContactPhoneDetail extends Backbone.RelationalModel

  getViewIcon: ->
    type = @get("type")

    if type == 'Home'
      return 'house'
    else if type == 'Business'
      return 'building-dark'
    else if type == 'Mobile'
      return 'mobile'
    else
      return 'phone'
    

  getViewValue: ->
    return @get("number")
