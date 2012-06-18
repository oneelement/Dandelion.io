class RippleApp.Views.ContactCardDetail extends Backbone.View
  template: JST['contact_manager/contact_details/detail']
  className: 'contact-detail'
  tagName: 'li'
  
  events:
    'dblclick span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.edit-icon': 'editValue'
    'click span.delete-icon': 'deleteValue'
    'focusout input#edit_value': 'closeEdit'
    'click #default-phone, #default-address, #default-email': 'toggleDefault'

  initialize: ->
    @icon = @options.icon
    @value = @options.value
    @model.on('change', @renderEdit, this)
    @modelType = @model.getModelType()
    @subject = @options.subject
    #console.log(@subject)
    $(@el).addClass(@modelType)

  render: ->
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType, detail: @model.toJSON()))
    
    defaultInd = @model.get('default')
    if defaultInd == true
      id = "#default-" + @modelType
      $(id, @el).attr('checked','checked')
    
    return this
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType, detail: @model.toJSON()))
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
    if @modelType != "hashtag"
      $(this.el).addClass('editing')
      this.$('input#edit_value').focus()
      this.$('span.edit-icon').css('display', 'block')
    
  deleteValue: ->
    if @modelType == 'hashtag'
      #coll = @model.getModelType()
      #coll = coll + 's'
      console.log('delete hashtag')
      console.log(@model)
      @collection.remove(@model)
      c = new RippleApp.Collections.Hashtags(@subject.get("hashtags"))
      c.remove(@model)
      console.log(@collection)
      @model.removeContact(@subject.get('_id'))
    else 
      console.log('model')
      @model.destroy()
    #@collection.remove(@model)
    #coll = @model.getModelType()
    #coll = coll + 's'
    #console.log(coll)
    #collection = @subject.get(coll)
    #collection.remove(@model)
    #console.log(collection)
    #console.log(@subject)
    #@subject
    #RippleApp.Views.ContactCard.saveModel
    #@subject.unset('hashtags', { silent: true })
    #@subject.save()
  
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    value = @model.getFieldName()
    this.model.set(value, this.$('input#edit_value').val())
    $(this.el).removeClass('editing')
    this.$('span.edit-icon').css('display', 'none')
