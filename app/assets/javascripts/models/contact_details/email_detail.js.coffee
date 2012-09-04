class RippleApp.Models.ContactEmailDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/emails'

  getViewIcon: ->
    type = @get("_type")

    if type == 'EmailPersonal'
      return 'paper-plane'
    else if type == 'EmailBusiness'
      return 'mail'
    else
      return 'mail'
      
  getTypes: ->
    types = [{icon: 'paper-plane', type: 'EmailPersonal', text: 'Personal Email'}, {icon: 'mail', type: 'EmailBusiness', text: 'Business Email'}]
    #types = ['EmailPersonal', 'EmailBusiness', 'Email']
    return types    

  getViewValue: ->
    return @get("text")
    
  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "email"
    
  defaultType: ->
    return "EmailPersonal"
