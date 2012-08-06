class RippleApp.Models.ContactEmailDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/emails'

  getViewIcon: ->
    type = @get("_type")

    if type == 'EmailPersonal'
      return 'mail'
    else if type == 'EmailBusiness'
      return 'mail'
    else
      return 'mail'
      
  getTypes: ->
    types = [{icon: 'EP', type: 'EmailPersonal'}, {icon: 'EB', type: 'EmailBusiness'}, {icon: 'EM', type: 'Email'}]
    #types = ['EmailPersonal', 'EmailBusiness', 'Email']
    return types    

  getViewValue: ->
    return @get("text")
    
  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "email"
