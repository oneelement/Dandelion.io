class RippleApp.Views.MergeMasterSelect extends Backbone.View
  template: JST['contact_manager/merge_master_select']
  id: 'merge-master-select'
  
  events:
    'click .complete-merge': 'completeMerge'
  
  initialize: ->
    @selected = @options.selected
    @source = @options.source
    @master = new RippleApp.Models.Contact()
    @favouriteContacts = RippleApp.contactsRouter.favouriteContacts 
    @recentContacts = RippleApp.contactsRouter.recentContacts
    @currentUser = RippleApp.contactsRouter.currentUser
   
  render: ->
    $(@el).html(@template())
    
    @selected.each(@appendList)
   
    return @
    
  appendList: (model) =>
    view = new RippleApp.Views.MergeEntry(model: model, selected: @selected, master: @master)
    this.$('#merge-table-body').append(view.render().el)
    
    
  completeMerge: ->
    if @source == 'contact'
      ids = @selected.pluck('_id')
      sent = ids
      console.log(sent)
      master = @master.get('_id')
      $('#merge-lightbox').css('display', 'none')
      $('.lightbox').removeClass('show')
      $('.lightbox').css('display', 'none')
      $('.lightbox').html('')
      $('.lightbox-backdrop').css('display', 'none')
      $.ajax '/contacts/multiplemerge', 
        type: 'GET'
        data: {sent: sent, master: master}
        success: (data) =>          
          @selected.remove(@master)
          @collection.remove(@selected.models)
          @favouriteContacts.remove(@selected.models)
          @recentContacts.remove(@selected.models)
          @selected.reset()
          @currentUser.set('favourite_contacts', JSON.stringify(@favouriteContacts))
          @currentUser.set('recent_contacts', JSON.stringify(@recentContacts))
          @currentUser.save()
          contact = @collection.get(master)
          contact.fetch()
      Backbone.history.navigate('#contacts', true)
    if @source == 'group'
      ids = @selected.pluck('_id')
      sent = ids
      console.log(sent)
      master = @master.get('_id')
      $('#merge-lightbox').css('display', 'none')
      $('.lightbox').removeClass('show')
      $('.lightbox').css('display', 'none')
      $('.lightbox').html('')
      $('.lightbox-backdrop').css('display', 'none')
      $.ajax '/groups/multiplemerge', 
        type: 'GET'
        data: {sent: sent, master: master}
        success: (data) =>          
          @selected.remove(@master)
          @collection.remove(@selected.models)
          @favouriteContacts.remove(@selected.models)
          @recentContacts.remove(@selected.models)
          @selected.reset()
          @currentUser.set('favourite_contacts', JSON.stringify(@favouriteContacts))
          @currentUser.set('recent_contacts', JSON.stringify(@recentContacts))
          @currentUser.save()
          group = @collection.get(master)
          group.fetch()
      Backbone.history.navigate('#groups', true)
    

    



