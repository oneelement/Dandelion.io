class RippleApp.Models.ContactSocialDetail extends Backbone.RelationalModel

  getViewIcon: ->
    return @get("type")

  getViewValue: ->
    return @get("social_id")
