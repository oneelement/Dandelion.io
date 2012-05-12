class RippleApp.Collections.RecentContacts extends Backbone.Collection
  model: RippleApp.Models.Contact
  url: '/recentcontacts'
  
  comparator: (contact)->
    contact.get('name')

  byName: ->
    sortedCollection = new RippleApp.Collections.Contacts(this.models)
    sortedCollection.comparator = (contact) ->
      return contact.get('name')
    sortedCollection.sort()
    return sortedCollection

  initialize: -> 
    @maxSize = 5
    @.on('add', @checkSize) 
    
  checkSize: -> 
    if @length > @maxSize 
      @models = @models.slice(-@maxSize) 

    


