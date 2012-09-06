class RippleApp.Views.ContactUserDetail extends Backbone.View
  template: JST['contact_manager/contact_details/detail']
  className: 'contact-user-detail'
  tagName: 'li'
  
  initialize: ->
    @icon = @options.icon
    @value = @options.value
    @model.on('change', @renderEdit, this)
    @modelType = @model.getModelType()
    @subject = @options.subject
    #console.log(@subject)
    $(@el).addClass(@modelType)
    if @options.source
      @source = @options.source

  render: ->
    $(@el).html(@template(source: @source, icon: @icon, value: @value, modeltype: @modelType, detail: @model.toJSON()))
    
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
    



  
