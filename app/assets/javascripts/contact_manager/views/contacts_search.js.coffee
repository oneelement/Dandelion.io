class RippleApp.Views.ContactsSearch extends Backbone.View
  template: JST['contact_manager/contact_search']
  #className: 'contact-list-items'  
  
  initialize: ->
    #@model.on('change', @render, this)
    
    
  

  render: ->
    $(@el).html(@template)
    @getSource()
    console.log("hello")
    return this

    
  getSource: ->
    @collection = new RippleApp.Collections.Contacts()
    @collection.fetch({success: @handleSuccess})

      
  handleSuccess: (collection, response) ->
    console.log(collection)
    console.log(response)
    test = collection.pluck("name")
    console.log(test)
    mysource = ['one', 'two']
    $('#autocomplete', @el).typeahead
      source: test
      items: 8
    .result
      test: (event, data) ->
	#alert "hello"

  

      
    

    

