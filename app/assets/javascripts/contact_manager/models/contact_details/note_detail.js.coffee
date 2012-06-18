class RippleApp.Models.ContactNoteDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    return 'pencil-dark'

  getViewValue: ->
    return @get("text")
    
  getTypes: ->
    types = []
    return types   

  getFieldName: ->
    return "text"
    
  getModelType: ->
    return "note"