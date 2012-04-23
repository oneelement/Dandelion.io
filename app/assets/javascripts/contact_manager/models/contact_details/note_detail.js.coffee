class RippleApp.Models.ContactNoteDetail extends Backbone.RelationalModel

  getViewIcon: ->
    return 'pencil-dark'

  getViewValue: ->
    return @get("text")
