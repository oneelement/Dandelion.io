class RippleApp.Collections.RecentContacts extends Backbone.Collection
  model: RippleApp.Models.Contact
  url: '/contacts'
  currentUser: new RippleApp.Models.User()
  idAttribute: '_id'
  
  comparator: (contact)->
    contact.get('name')

  byName: ->
    sortedCollection = new RippleApp.Collections.Contacts(this.models)
    sortedCollection.comparator = (contact) ->
      return contact.get('name')
    sortedCollection.sort()
    return sortedCollection

  initialize: -> 
    @currentUser.fetchCurrent(success: (userModel) =>
      _.each(userModel.get('recent_ids'), (contact_id) =>
        contact = new RippleApp.Models.Contact({_id: contact_id})
        contact.fetch(success: (contact) =>
          this.add(contact, {'initialize':'true'})
        )
      )
    )
    @maxSize = 5
    
  add: (model, options = {}) =>        
    overlookedUser = _.first(@models)
    Backbone.Collection.prototype.add.call(@, model)
    if @length > @maxSize
      @.remove(overlookedUser)
        
    if not options.initialize  
      recentUserIds = @.pluck('_id')
      @currentUser.set('recent_ids', recentUserIds).save()

