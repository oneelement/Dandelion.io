class RippleApp.Models.ContactPhoneDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/admins'

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
      
  getTypes: ->
    #types = ['PhoneHome', 'PhoneBusiness', 'PhoneMobile', 'Phone']
    types = [{icon: 'PH', type: 'PhoneHome'}, {icon: 'PB', type: 'PhoneBusiness'}, {icon: 'PM', type: 'PhoneMobile'}, {icon: 'PH', type: 'Phone'}]
    return types       

  getViewValue: ->
    return @get("number")
    
  getFieldName: ->
    return "number"
    
  getModelType: ->
    return "phone"
