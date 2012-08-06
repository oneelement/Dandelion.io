class RippleApp.Views.ContactUserSection extends Backbone.View
  template: JST['contact_manager/contact_card_section']
  className: 'contact-card-section'
  

  initialize: ->
    @collection.on('add', @addDetail)
    @collection.on('remove', @render, this)
    @collection.on('reset', @clearDetails)
    @title = @options.title
    @icon = @options.icon
    @sectionIsActive = false
    @subject = @options.subject
    #@subject.on('change', @render, this)  #re-renders on subject change to fetch extra values form server
    @modelName = @options.modelName
    @dummyModel = new @modelName
    @types = @dummyModel.getTypes()
    @modelType = @dummyModel.getModelType()

  render: ->
    console.log('contact card section render')
    $(@el).html(@template(title: @title, icon: @icon, types: @types, modelType: @modelType))

    if @collection.models.length > 0
      @makeTitleActive()

      _.each(@collection.models, (model) =>
        @addDetail(model, false))
    @
    

  makeTitleActive: () ->
    if not @sectionIsActive
      this.$('.contact-card-section-title').addClass('active')
      @sectionIsActive = true
    else
      if this.$('.contact-card-section-title').hasClass('active')
      else
        this.$('.contact-card-section-title').addClass('active')  

  buildDetailEl: (model) =>
    return $(new RippleApp.Views.ContactUserDetail(
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
