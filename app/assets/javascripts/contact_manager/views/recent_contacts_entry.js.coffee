class RippleApp.Views.RecentContactsEntry extends Backbone.View
  template: JST['contact_manager/recent_contacts_entry']
  tagName: 'li'

  render: ->
    isCurrent = (RippleApp.contactsRouter.currentContact.id == @model.id)
    if (isCurrent)
      @$el.addClass('active')
    else
      if @$el.hasClass('active')
        @$el.removeClass('active')

    $(@el).html(@template(model: @model.toJSON(), isCurrent: isCurrent))
    @

  events:
    "click": "clicked"

  clicked: ->
    RippleApp.router.navigate('show/' + @model.id, {
      trigger: true
    })
