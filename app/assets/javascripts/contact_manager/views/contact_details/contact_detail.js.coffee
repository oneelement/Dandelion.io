class RippleApp.Views.ContactCardDetail extends Backbone.View
  template: JST['contact_manager/contact_details/detail']
  className: 'contact-detail'
  tagName: 'li'

  initialize: ->
    console.log(@options)
    @icon = @options.icon
    @value = @options.value

  render: ->
    $(@el).html(@template(icon: @icon, value: @value))
    @
