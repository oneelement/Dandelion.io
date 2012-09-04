class RippleApp.Models.ContactUrlDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/urls'

  getViewIcon: ->
    type = @get("_type")

    if type == 'UrlPersonal'
      return 'globe'
    else if type == 'UrlBusiness'
      return 'office'
    else
      return 'globe'
      
  getTypes: ->
    #types = ['UrlPersonal', 'UrlCompany', 'Url']
    types = [{icon: 'globe', type: 'UrlPersonal', text: 'Personal Website'}, {icon: 'office', type: 'UrlBusiness', text: 'Business Website'}]
    return types       

  getViewValue: ->
    return @get("text")
    
  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "url"
    
  defaultType: ->
    return "UrlPersonal"
