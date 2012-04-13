class ContactManager.Views.ContactsTree extends Backbone.View
  template: JST['contact_manager/contact_tree']
  tagName: 'li'
  className: 'contact-tree'
  
  initialize: ->
    #@model.on('change', @render, this)
    @collection = new ContactManager.Collections.Latestcontacts()
    #@collection.fetch()
    #@collection.on('reset', @render, this)
  
  #events:
    #'click .contact-icon': 'activeContact'
    
  render: ->
    $(@el).html(@template(contacts: @collection))
    this
    
  #activeContact: (event) ->
    #if ($(this.el).hasClass('active'))      
    #else
      #$("li").removeClass('active')
      #$(this.el).addClass('active')
      #$("#contact-profiles div").removeClass('contact-active')
      #test = "#" + this.model.get('_id')
     #$(test).parent('div').addClass("contact-active")
    
