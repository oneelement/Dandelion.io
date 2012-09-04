class RippleApp.Views.ContactCardDetail extends Backbone.View
  template: JST['contact_manager/contact_details/detail']
  className: 'contact-detail'
  tagName: 'li'
  
  events:
    #'click span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.contact-detail-delete': 'deleteValue'
    'focusout input#edit_value': 'closeEdit'
    'click .main-icon': 'toggleDefault'

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
      this.$('.main-icon').addClass('default-active')
    
    return this
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType, detail: @model.toJSON()))
    defaultInd = @model.get('default')
    if defaultInd == true
      this.$('.main-icon').addClass('default-active')

      
    return this
    
  toggleDefault: ->
    if @modelType != 'Note'
      @setDefault()
    
  setDefault: ->
    if @model.get('default') == true
      _.each(@collection.models, (model) ->
        model.set('default', false)
      )
      this.$('.main-icon').removeClass('default-active')
    else  
      _.each(@collection.models, (model) ->
        model.set('default', false)
      )
      @model.set('default', true)
      this.$('.main-icon').addClass('default-active')

    
  
  editValue: ->
    if @modelType != "hashtag"
      $(this.el).addClass('editing')
      this.$('input#edit_value').focus()
      this.$('span.edit-icon').css('display', 'block')
      this.$('.contact-detail-delete').css('color', '#DDD')
      #this.$('.contact-detail-favorite').css('display', 'none')
      #this.$('.contact-detail-delete').addClass('delete-icon')
    
  deleteValue: ->
    console.log('Delete Entry')
    @model.destroy(null, { silent: true })
    #@model.destroyModel(@model.get('_id'), @subject.get('_id'))
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
    console.log('close edit detail')
    value = @model.getFieldName()
    this.model.set(value, this.$('input#edit_value').val())
    #$(this.el).removeClass('editing')
    #this.$('.contact-detail-delete').removeClass('delete-icon')
    #this.$('.contact-detail-favorite').css('display', 'block')
    #this.$('.contact-detail-delete').css('color', '#FFF')
    @model.save()
