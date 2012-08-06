class RippleApp.Collections.Contacts extends Backbone.Collection
    model: RippleApp.Models.Contact
    url: '/contacts'
    
    comparator: (contact)->
      contact.get('name')

    byName: ->
      sortedCollection = new RippleApp.Collections.Contacts(this.models)
      sortedCollection.comparator = (contact) ->
        return contact.get('name')
      sortedCollection.sort()
      return sortedCollection

    


