class RippleApp.Models.ContactPhoneDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/phones'

  getViewIcon: ->
    type = @get("_type")

    if type == 'PhoneHome'
      return 'phone'
    else if type == 'PhoneBusiness'
      return 'phone'
    else if type == 'PhoneMobileBusiness'
      return 'mobile'
    else if type == 'PhoneMobile'
      return 'mobile'
    else
      return 'phone'
      
  getTypes: ->
    #types = ['PhoneHome', 'PhoneBusiness', 'PhoneMobile', 'Phone']
    types = [{icon: 'PH', type: 'PhoneHome'}, {icon: 'PB', type: 'PhoneBusiness'}, {icon: 'PMB', type: 'PhoneMobileBusiness'}, {icon: 'PM', type: 'PhoneMobile'}, {icon: 'PH', type: 'Phone'}]
    return types       

  getViewValue: ->
    return @get("number")
    
  getFieldName: ->
    return "number"
    
  getModelType: ->
    return "phone"
    
  destroyModel: (id, contact_id) ->
    url = '/admins/tester/?id=' + id + '&contact_id=' + contact_id
    $.get(url)
    
