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
    'click .trigger-address': 'triggerMap'
    'click .trigger-phone': 'triggerPhone'

  initialize: ->
    @icon = @options.icon
    @value = @options.value
    @model.on('change', @renderEdit, this)
    @modelType = @model.getModelType()
    @subject = @options.subject
    #console.log(@subject)
    $(@el).addClass(@modelType)

  render: ->
    if @value
      begin_value = @value.substr(0,4)
    else
      begin_value = ""      
    console.log(begin_value)
    $(@el).html(@template(icon: @icon, value: @value, beg_val: begin_value, modeltype: @modelType, detail: @model.toJSON()))
    defaultInd = @model.get('default')
    if defaultInd == true
      this.$('.main-icon').addClass('default-active')
      
    if @model.get('parent_id')
      $(this.el).addClass('uneditable')
      
    if @modelType == 'address'
      this.$('span.contact-detail-value').addClass('trigger-address')
      
    if @modelType == 'phone'
      this.$('span.contact-detail-value').addClass('trigger-phone')
    
    return this
    
  renderEdit: ->
    @value = @model.getViewValue()
    $(@el).html(@template(icon: @icon, value: @value, modeltype: @modelType, detail: @model.toJSON()))
    defaultInd = @model.get('default')
    if defaultInd == true
      this.$('.main-icon').addClass('default-active')
      
    if @model.get('parent_id')
      $(this.el).addClass('uneditable')
      
    if @modelType == 'address'
      this.$('span.contact-detail-value').addClass('trigger-address')
      
    if @modelType == 'phone'
      this.$('span.contact-detail-value').addClass('trigger-phone')

      
    return this
    
  triggerMap: ->
    if @model.get('coordinates')
      console.log('trigger map')
      $('#expanded-map').css('display','block')
      $('.lightboxmap').addClass('show').addClass('map')
      $('.lightboxmap').css('display', 'block')
      $('.lightbox-backdrop').css('display', 'block')
      c = new RippleApp.Collections.Addresses()
      c.add(@model)
      map = new RippleApp.Views.LightboxMap(
        collection: c
      )
      $('.lightboxmap', @el).append(map.render().el)
    
  triggerPhone: ->
    $('.lightbox-backdrop').css('display', 'block')
    $('#phone-lightbox-container').css('display', 'block')
    $('#phone-lightbox-value').css('display', 'block')
    $('#phone-lightbox-value').html(@value)
    container_width = $('#phone-lightbox-container').width()
    value_width = $('#phone-lightbox-value').width()
    console.log(container_width)
    console.log(value_width)
    new_cont_width = container_width * 0.8
    font_multiple = new_cont_width / value_width
    font_multiple = parseInt(font_multiple)
    console.log(font_multiple)
    fontsize = font_multiple * 10
    $('#phone-lightbox-value').css('font-size', fontsize)
    new_value_width = $('#phone-lightbox-value').width()
    value_margin = (container_width - new_value_width) / 2
    value_margin_px = String(value_margin) + "px"
    $('#phone-lightbox-value').css('margin-left', value_margin_px)
    
    
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
