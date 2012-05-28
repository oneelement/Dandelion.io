class RippleApp.Views.ContactBadge extends Backbone.View
  template: JST['contact_manager/contact_badge']

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
    @

  events:
    "click": "clicked"

  clicked: ->   
    Backbone.history.navigate('contacts/show/' + @model.id, true)
