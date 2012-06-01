class RippleApp.Models.Hashtag extends Backbone.RelationalModel
  urlRoot: '/hashtags'
  idAttribute: '_id'
  
  getViewIcon: ->
      return 'hashtag'
  
  getViewValue: ->
    return @get("text")
    
  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "hashtag"