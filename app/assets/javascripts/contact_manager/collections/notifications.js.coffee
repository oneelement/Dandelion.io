class RippleApp.Collections.Notifications extends Backbone.Collection
  model: RippleApp.Models.Notification
  url: '/notifications'
  
  unread: ->
    unread = this.where(is_read: false, is_actioned: false)
    return unread
    
  un_actioned: ->
    un_actioned = this.where(is_actioned: false)
    return un_actioned

