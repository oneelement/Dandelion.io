class RippleApp.Models.ContactUrlDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/urls'

  getViewIcon: ->
    type = @get("_type")

    if type == 'UrlPersonal'
      return 'link'
    else if type == 'UrlCompany'
      return 'link'
    else
      return 'link'
      
  getTypes: ->
    #types = ['UrlPersonal', 'UrlCompany', 'Url']
    types = [{icon: 'UP', type: 'UrlPersonal'}, {icon: 'UC', type: 'UrlCompany'}, {icon: 'UL', type: 'Url'}]
    return types       

  getViewValue: ->
    return @get("text")
    
  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "url"
