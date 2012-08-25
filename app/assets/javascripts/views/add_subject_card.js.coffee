class RippleApp.Views.AddSubjectCard extends Backbone.View
  template: JST['contact_manager/add_subject_card']
  id: 'contact-card'
    
  events:
    'keypress #subject_name_input': 'checkNameEnter'

    
  initialize: ->
    @source = @options.source
    @model.on('change', @render, this)
    @contacts = RippleApp.contactsRouter.contacts
  
  render: ->
    $(@el).html(@template(contact: @model.toJSON(), source: @source))
      
    @outputMap()
    
    return @
    
  outputMap: ->
    map = new RippleApp.Views.ContactCardMap(
      collection: @model.get("addresses")
    )
    $('#contact-card-map', @el).append(map.render().el)
    
  checkNameEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeNameEdit()
      
  closeNameEdit: ->
    this.model.set('name', this.$('input#subject_name_input').val())
    if @model.isNew() 
      modelname = @model.getModelName()
      if modelname == "contact"
        @model.unset('hashtags', { silent: true })
        @model.save(null, success: (model) => 
          @contacts.add(model)
          console.log(model)
          Backbone.history.navigate('#contacts/preview/'  + model.id, true)
        )
      else if modelname == "group"
        @model.unset('hashtags', { silent: true })
        @model.save(null, success: (model) => 
          RippleApp.contactsRouter.groups.add(model)
          Backbone.history.navigate('#groups/preview/'  + model.id, true)
        ) 