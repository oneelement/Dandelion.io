class RippleApp.Models.ContactPositionDetail extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: '/positions'

  getViewIcon: ->
    type = @get("_type")

    if type == 'Position'
      return 'briefcase-3'
    else
      return 'briefcase-3'
      
  getTypes: ->
    #types = ['PhoneHome', 'PhoneBusiness', 'PhoneMobile', 'Phone']
    types = [{icon: 'briefcase-3', type: 'Position', text: 'Position'}]
    return types       

  getViewValue: ->
    return @get("title")
    
  getFieldName: ->
    return "title"
    
  getModelType: ->
    return "position"
    
  defaultType: ->
    return "Position"

    
