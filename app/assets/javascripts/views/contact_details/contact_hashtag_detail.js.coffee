class RippleApp.Views.ContactCardHashtagDetail extends Backbone.View
  template: JST['contact_manager/contact_details/hashtag_detail']
  className: 'contact-hashtag-detail'
  
  events:
    'dblclick span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.edit-icon': 'editValue'
    'click span.contact-detail-remove-hashtag': 'deleteValue'
    'focusout input#edit_value': 'closeEdit'
    'hover .contact-detail-remove-hashtag': 'removeHover'
    'click .contact-detail-value': 'showTag'

  initialize: ->
    if @options.value
      @value = @options.value
    else
      @value = @model.get('text')
    @model.on('change', @renderEdit, this)
    if @options.subject
      @subject = @options.subject
    @modelType = @model.getModelType()
    $(@el).addClass(@modelType)

  render: ->
    $(@el).html(@template(value: @value, detail: @model.toJSON()))
    
    return this
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(value: @value, detail: @model.toJSON()))
      
    return this
    
  showTag: ->
    Backbone.history.navigate('hashtags/show/' + @model.id, true)
    
 
  editValue: ->
    $(this.el).addClass('editing')
    this.$('input#edit_value').focus()
    this.$('span.edit-icon').css('display', 'block')
    
  deleteValue: =>
    console.log('delete hashtag')
    console.log('coll' + @collection)
    console.log(@collection)
    @collection.remove(@model)
    console.log('coll' + @collection)
    console.log(@collection)
    console.log('subject' + @subject.get("hashtags"))
    c = new RippleApp.Collections.Hashtags(@subject.get("hashtags"))
    c.remove(@model)
    console.log(@collection)
    @model.removeContact(@subject.get('_id'))
    console.log('subject' + @subject.get("hashtags"))
    #@subject.unset('hashtags', { silent: true })
    @subject.set('hashtags', c.models)
    #@subject.unset('hashtags', { silent: true })
    #@subject.save()
    console.log(@subject)

  
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    value = @model.getFieldName()
    this.model.set(value, this.$('input#edit_value').val())
    $(this.el).removeClass('editing')
    this.$('span.edit-icon').css('display', 'none')
    
  removeHover: ->
    $(this.el).toggleClass('remove')
