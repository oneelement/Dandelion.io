class RippleApp.Collections.RecentContacts extends Backbone.Collection
  model: RippleApp.Models.Contact
  url: '/contacts'
  #user: new RippleApp.Models.User()
  currentUser: new RippleApp.Models.User()
  
  comparator: (contact)->
    contact.get('name')

  byName: ->
    sortedCollection = new RippleApp.Collections.Contacts(this.models)
    sortedCollection.comparator = (contact) ->
      return contact.get('name')
    sortedCollection.sort()
    return sortedCollection

  initialize: -> 
    @currentUser.fetchCurrent(success: (model) =>
      _.each(model.get('recent_ids'), (contact_id) =>
        contact = new RippleApp.Models.Contact({_id: contact_id})
        contact.fetch(success: (contact) =>
          #unsure if this will add to self?? cant test atm as user object not being saved to db :( ew
          #had to add a couple of this' to make this work OC
          console.log(contact)
          this.add(contact)
        )
      )
    )
    @maxSize = 5
    @.on('add', @checkSizeAndSave) 
    
  checkSizeAndSave: => 
    if @length > @maxSize 
      #gone = this.last()
      #console.log(gone)
      @models = @models.slice(-@maxSize)
      #first = this.first()
      #console.log(first)
      #this.remove(first)
      #models = this
      #this.reset(@models)
    recentUserIds = []
    _.each(@models, (contact) ->
      recentUserIds.push(contact.get('_id'))
    )
    @currentUser.set('recent_ids', recentUserIds)
    #currently not saving to database
    @currentUser.save()


