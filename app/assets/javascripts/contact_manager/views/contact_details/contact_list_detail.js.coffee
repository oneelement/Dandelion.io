class RippleApp.Views.ContactListDetail extends Backbone.View
  template: JST['contact_manager/contact_details/contact_list_detail']
  
  events:
    'dblclick span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.edit-icon': 'editValue'
    'focusout input#edit_value': 'closeEdit'

  initialize: ->
    @icon = @options.icon
    @value = @options.value
    @model.on('change', @render, this)

  render: ->
    $(@el).html(@template(icon: @icon, value: @model.get(@value)))
    @
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(icon: @icon, value: @value))
    @
    
  
  editValue: ->
    $(this.el).addClass('editing')
    this.$('input#edit_value').focus()
    this.$('span.edit-icon').css('display', 'block')
  
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    #value = @model.getFieldName()
    this.model.set(@value, this.$('input#edit_value').val())
    console.log(@model)
    $(this.el).removeClass('editing')
    this.$('span.edit-icon').css('display', 'none')
