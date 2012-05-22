class RippleApp.Models.ContactEmailDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    type = @get("_type")

    if type == 'EmailPersonal'
      return 'house'
    else if type == 'EmailBusiness'
      return 'building-dark'
    else
      return 'phone'
    

  getViewValue: ->
    return @get("email")
    
  getFieldName: ->
    return "email"
