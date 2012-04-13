class ContactManager.Views.ContactsTreeEntry extends Backbone.View
  template: JST['contact_manager/contact_tree_entry']
  tagName: 'li'
  className: 'contact-tree-entry'

  render: ->
    isCurrent = (ContactManager.router.currentContact.id == @model.id)
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
    ContactManager.router.navigate('show/' + @model.id, {
      trigger: true
    })
