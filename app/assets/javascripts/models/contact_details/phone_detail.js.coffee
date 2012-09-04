class RippleApp.Models.ContactPhoneDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/phones'

  getViewIcon: ->
    type = @get("_type")

    if type == 'PhonePersonal'
      return 'phone'
    else if type == 'PhoneBusiness'
      return 'office'
    else if type == 'MobileBusiness'
      return 'mobile-2'
    else if type == 'MobilePersonal'
      return 'mobile'
    else
      return 'phone'
      
  getTypes: ->
    #types = ['PhoneHome', 'PhoneBusiness', 'PhoneMobile', 'Phone']
    types = [{icon: 'phone', type: 'PhonePersonal', text: 'Personal Phone'}, {icon: 'mobile', type: 'MobilePersonal', text: 'Personal Mobile'}, {icon: 'office', type: 'PhoneBusiness', text: 'Business Phone'}, {icon: 'mobile-2', type: 'MobileBusiness', text: 'Business Mobile'}]
    return types       

  getViewValue: ->
    return @get("number")
    
  getFieldName: ->
    return "number"
    
  getModelType: ->
    return "phone"
    
  defaultType: ->
    return "PhonePersonal"
    
  destroyModel: (id, contact_id) ->
    url = '/admins/tester/?id=' + id + '&contact_id=' + contact_id
    $.get(url)
    
