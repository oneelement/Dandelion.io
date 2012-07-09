class RippleApp.Views.ContactCardDetail extends Backbone.View
  template: JST['contact_manager/contact_details/detail']
  className: 'contact-detail'
  tagName: 'li'
  
  events:
    'click span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.edit-icon': 'editValue'
    'click span.delete-icon': 'deleteValue'
    'focusout input#edit_value': 'closeEdit'
    'click #default-phone, #default-address, #default-email': 'toggleDefault'
    'click .contact-detail-favorite': 'toggleNew'

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
      this.$('.contact-detail-favorite').addClass('favorite-active')
    
    return this
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType, detail: @model.toJSON()))
    defaultInd = @model.get('default')
    id = "#default-" + @modelType
    if defaultInd == true
      $(id, @el).attr('checked', true)
      this.$('.contact-detail-favorite').addClass('favorite-active')
    else
      $(id, @el).attr('checked', false)
      
    return this
    
  toggleNew: ->
    console.log('toggle new')
    if @model.get('default') == true
      _.each(@collection.models, (model) ->
        model.set('default', false)
        #model.save(null, { silent: true })
      )
      this.$('.contact-detail-favorite').removeClass('favorite-active')
    else  
      _.each(@collection.models, (model) ->
        model.set('default', false)
        #model.save(null, { silent: true })
      )
      @model.set('default', true)
      this.$('.contact-detail-favorite').addClass('favorite-active')
    console.log(@model.get('default'))
    #@model.save(null, { silent: true })
    
 
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
      this.$('.contact-detail-delete').css('color', '#DDD')
      this.$('.contact-detail-favorite').css('display', 'none')
      this.$('.contact-detail-delete').addClass('delete-icon')
    
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
    value = @model.getFieldName()
    this.model.set(value, this.$('input#edit_value').val())
    $(this.el).removeClass('editing')
    this.$('span.edit-icon').css('display', 'none')
    this.$('.contact-detail-delete').removeClass('delete-icon')
    this.$('.contact-detail-favorite').css('display', 'block')
    this.$('.contact-detail-delete').css('color', '#FFF')
    @model.save()
