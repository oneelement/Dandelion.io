class RippleApp.Views.ContactCardSection extends Backbone.View
  template: JST['contact_manager/contact_card_section']
  className: 'contact-card-section'
  
  events:
    'keypress .subject_edit_view_input': 'checkEnter'

  initialize: ->
    @collection.on('add', @addDetail)
    @collection.on('remove', @render, this)
    @collection.on('reset', @clearDetails)
    @title = @options.title
    @sectionIsActive = false
    @subject = @options.subject
    @modelName = @options.modelName
    @dummyModel = new @modelName
    @types = @dummyModel.getTypes()
    @modelType = @dummyModel.getModelType()
    if @options.hashes
      @hashtags = @options.hashes

  render: ->
    $(@el).html(@template(title: @title, types: @types, modelType: @modelType))
    
    console.log(@collection.models.length)

    if @collection.models.length > 0
      @makeTitleActive()

      _.each(@collection.models, (model) =>
        @addDetail(model, false))
    @
    
  checkEnter: (event) ->
    if @modelType == 'hashtag'
      val = this.$('input.subject_edit_view_input').val()
      hashtags = []
      _.each(@hashtags.toJSON(), (hashtag)=>
        hashtags.push(hashtag.text)
      )
      this.$('input.subject_edit_view_input').autocomplete(source: hashtags)
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    type = this.$(".item-type option:selected").val()
    val = this.$('input.subject_edit_view_input').val()
    if @modelType == 'hashtag'
      c = new RippleApp.Collections.Hashtags(@subject.get("hashtags")) 
      isDuplicate = false
      _.each(c.models, (hashtag) =>
        if hashtag.get('text') is val
          isDuplicate = true
      )
      if not isDuplicate
        #@collection.remove(@collection.models)
        contact_id = @subject.get('_id')
        newmodel = @hashtags.addTagToContact(val, contact_id)
        @collection.add(newmodel)
        this.$('input.subject_edit_view_input').val('')  
    else
      m = new @modelName
      field = m.getFieldName()
      m.set(field, val, {silent: true})
      m.set('_type', type, {silent: true})
      @collection.add(m)
      @subject.save(null, {silent: true})
      this.$('input.subject_edit_view_input').val('')  
    

  makeTitleActive: () ->
    if not @sectionIsActive
      this.$('.contact-card-section-title').addClass('active')
      @sectionIsActive = true
    else
      if this.$('.contact-card-section-title').hasClass('active')
      else
        this.$('.contact-card-section-title').addClass('active')  

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
    @makeTitleActive()

    if animate
      $detailEl.fadeIn(500)
