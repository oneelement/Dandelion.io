class RippleApp.Models.ContactSocialDetail extends Backbone.RelationalModel
  idAttribute: '_id'

  getViewIcon: ->
    type = @get("_type")
    if type == 'SocialTwitter'
      return 'twitter'
    else if type == 'SocialFacebook'
      return 'facebook'
    else if type == 'SocialLinkedin'
      return 'linkedin'

  getViewValue: ->
    return @get("social_id")
