class RippleApp.Models.ContactUrlDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    type = @get("_type")

    if type == 'UrlPersonal'
      return 'personal site'
    else if type == 'UrlCompany'
      return 'company url'
    else
      return 'url'
    

  getViewValue: ->
    console.log('in the model : '+@get("url"))
    return @get("url")
    
  getFieldName: ->
    return "url"
