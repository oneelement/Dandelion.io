class RippleApp.Views.ContactCardDetail extends Backbone.View
  template: JST['contact_manager/contact_details/detail']
  className: 'contact-detail'
  tagName: 'li'
  
  events:
    'dblclick span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.edit-icon': 'editValue'
    'focusout input#edit_value': 'closeEdit'
    'click #default-phone, #default-address, #default-email': 'toggleDefault'

  initialize: ->
    #console.log(@options)
    @icon = @options.icon
    @value = @options.value
    @model.on('change', @renderEdit, this)
    @modelType = @model.getModelType()

  render: ->
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType))
    
    defaultInd = @model.get('default')
    if defaultInd == true
      id = "#default-" + @modelType
      $(id, @el).attr('checked','checked')
    
    return this
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType))
    defaultInd = @model.get('default')
    id = "#default-" + @modelType
    if defaultInd == true
      $(id, @el).attr('checked', true)
    else
      $(id, @el).attr('checked', false)
      
    return this
    
 
  toggleDefault: (e) ->
    _.each(@collection.models, (model) ->
      model.set('default', false)
    )
    if e.target.checked == true
      @model.set('default', true)
    else  
      @model.set('default', false)
  
  editValue: ->
    $(this.el).addClass('editing')
    this.$('input#edit_value').focus()
    this.$('span.edit-icon').css('display', 'block')
  
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    value = @model.getFieldName()
    this.model.set(value, this.$('input#edit_value').val())
    console.log(@model)
    $(this.el).removeClass('editing')
    this.$('span.edit-icon').css('display', 'none')
