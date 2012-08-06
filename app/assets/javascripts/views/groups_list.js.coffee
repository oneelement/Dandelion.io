class RippleApp.Views.GroupsList extends Backbone.View
  template: JST['contact_manager/groups/group_list']
  tagName: 'tr'
  className: 'group-list-item'
  
  initialize: ->
    @model.on('change', @render, this)
  
  events:
    #'click': 'previewGroup'
    'click .close': 'destroyGroup'
    'click #open-action': 'openGroup'
    

  render: ->
    $(@el).html(@template(group: @model.toJSON()))
    @getSections()
    
    return this
    
  getSections: =>
    viewPhone = new RippleApp.Views.ContactListSection(collection: @model.get('phones'))
    this.$('.phone-details').append(viewPhone.render().el)    
    viewEmail = new RippleApp.Views.ContactListSection(collection: @model.get('emails'))
    this.$('.email-details').append(viewEmail.render().el)
  
  previewGroup: (event) ->
    Backbone.history.navigate('#groups/preview/' + @model.id, true)
      
  destroyGroup: ->
    getrid = confirm "Are you sure you want to delete this group?"
    if getrid == true
      this.model.destroy()
      $("#group-container").html('')

  openGroup: ->
    Backbone.history.navigate('#groups/show/'+ @model.id, true)
