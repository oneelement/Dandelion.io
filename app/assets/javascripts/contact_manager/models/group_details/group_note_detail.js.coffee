class RippleApp.Models.GroupNoteDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    return 'pencil-dark'

  getViewValue: ->
    return @get("text")

  getFieldName: ->
    return "text"