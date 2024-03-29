class RippleApp.Views.ContactCardSection extends Backbone.View
  template: JST['contact_manager/contact_card_section']
  className: 'contact-card-section'
  
  events:
    'keypress .subject_edit_view_input': 'checkEnter'
    'click #default-icon': 'initEditType'
    'click .icon-option-select': 'selectEditType'
    
  initialize: ->
    @collection.on('add', @addDetail, this)
    @collection.on('remove', @render, this)
    @collection.on('reset', @clearDetails, this)
    @title = @options.title
    @icon = @options.icon
    @sectionIsActive = false
    @subject = @options.subject
    #@subject.on('change', @render, this)  #re-renders on subject change to fetch extra values form server
    @modelName = @options.modelName #e.g. RippleApp.Models.xxx
    @dummyModel = new @modelName
    @types = @dummyModel.getTypes()
    @modelType = @dummyModel.getModelType()
    @defaultType = @dummyModel.defaultType()

  render: ->
    console.log('contact card section render')
    $(@el).html(@template(title: @title, icon: @icon, types: @types, defaultType: @defaultType, modelType: @modelType))
    
    console.log(@modelType)
    #console.log(@collection.models.length)

    if @collection.models.length > 0
      _.each(@collection.models, (model) =>
        @addDetail(model, false))
      
    return this
    
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    console.log('close edit')
    type = this.$('#default-icon').attr('title')
    if @modelType == 'position'
      title = this.$('input#subject_edit_view_input_title').val()
      company = this.$('input#subject_edit_view_input_company').val()
      m = new @modelName
      m.set('title', title, {silent: true})
      m.set('company', company, {silent: true})
      m.set('_type', type, {silent: true})
      if @subject.get('current_position') == null && @subject.get('current_company') == null
        @subject.set('current_position', title)
        @subject.set('current_company', company)
    else
      val = this.$('input.subject_edit_view_input').val()
      m = new @modelName
      field = m.getFieldName()
      m.set(field, val, {silent: true})
      m.set('_type', type, {silent: true})
    @collection.add(m)
    @subject.save(null, {silent: true})
    this.$('input.subject_edit_view_input').val('')  
    
  initEditType: ->
    this.$('.edit-view-icon-options').css('display', 'block')
    
  selectEditType: (event) ->
    console.log(event.target.title)
    edit_icon = $(event.target).attr('data-icon')
    icon = "dicon-" + edit_icon
    console.log(edit_icon)
    edit_title = event.target.title
    this.$('#default-icon').removeAttr('class')
    this.$('#default-icon').addClass('contact-detail-icon').addClass(icon)
    this.$('#default-icon').attr('title', edit_title)
    this.$('.edit-view-icon-options').css('display', 'none')
    

  buildDetailEl: (model) =>
    return $(new RippleApp.Views.ContactCardDetail(
      model: model
      icon: model.getViewIcon()
      value: model.getViewValue()
      collection: @collection
      subject: @subject
    ).render().el)

  clearDetails: =>
    $detailsList = $('.contact-details-list', @el).empty()

  addDetail: (model, animate) =>
    classname = @title.split(" ")
    $detailsList = $('.contact-details-list', @el).addClass(classname[0])
    $detailEl = @buildDetailEl(model)

    if animate
      $detailEl.css('display', 'none')

    $detailsList.append($detailEl)

    if animate
      $detailEl.fadeIn(0)
