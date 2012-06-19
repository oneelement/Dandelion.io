class RippleApp.Models.ContactEmailDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/emails'

  getViewIcon: ->
    type = @get("_type")

    if type == 'EmailPersonal'
      return 'house'
    else if type == 'EmailBusiness'
      return 'building-dark'
    else
      return 'phone'
      
  getTypes: ->
    types = [{icon: 'EP', type: 'EmailPersonal'}, {icon: 'EB', type: 'EmailBusiness'}, {icon: 'EM', type: 'Email'}]
    #types = ['EmailPersonal', 'EmailBusiness', 'Email']
    return types    

  getViewValue: ->
    return @get("email")
    
  getFieldName: ->
    return "email"
    
  getModelType: ->
    return "email"
