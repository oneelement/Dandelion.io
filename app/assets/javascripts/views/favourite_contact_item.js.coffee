class RippleApp.Views.ContactBadge extends Backbone.View
  template: JST['contact_manager/contact_badge']
  className: 'favorite-item'

  render: ->
    isContextContact = false

    contextContact = RippleApp.contactsRouter.contextContact()
    if (contextContact)
      isContextContact = (contextContact.id == @model.id)

    if (isContextContact)
      @$el.addClass('active')
    else
      if @$el.hasClass('active')
        @$el.removeClass('active')
    $(@el).html(@template(model: @model.toJSON()), isSelected: isContextContact)
    
    return this
    
  events:
    "click": "clicked"

  clicked: ->   
    console.log(@model)
    if @model.get('type') == 'contact'
      Backbone.history.navigate('contacts/show/' + @model.id, true)
    else if @model.get('type') == 'group'
      Backbone.history.navigate('groups/show/' + @model.id, true)