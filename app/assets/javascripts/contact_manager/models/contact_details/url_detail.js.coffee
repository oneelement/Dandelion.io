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
      
  getTypes: ->
    #types = ['UrlPersonal', 'UrlCompany', 'Url']
    types = [{icon: 'UP', type: 'UrlPersonal'}, {icon: 'UC', type: 'UrlCompany'}, {icon: 'UL', type: 'Url'}]
    return types       

  getViewValue: ->
    return @get("url")
    
  getFieldName: ->
    return "url"
    
  getModelType: ->
    return "url"
