class RippleApp.Models.ContactEducationDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/educations'

  getViewIcon: ->
    type = @get("_type")

    if type == 'Education'
      return 'graduation'
    else
      return 'graduation'
      
  getTypes: ->
    #types = ['PhoneHome', 'PhoneBusiness', 'PhoneMobile', 'Phone']
    types = [{icon: 'graduation', type: 'Education', text: 'Education'}]
    return types       

  getViewValue: ->
    return @get("title")
    
  getFieldName: ->
    return "title"
    
  getModelType: ->
    return "education"
    
  defaultType: ->
    return "Education"

    
