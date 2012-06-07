class RippleApp.Views.ContactCardSection extends Backbone.View
  template: JST['contact_manager/contact_card_section']
  className: 'contact-card-section'

  initialize: ->
    @collection.on('add', @addDetail)
    @collection.on('remove', @render, this)
    @collection.on('reset', @clearDetails)
    @title = @options.title
    @sectionIsActive = false
    @subject = @options.subject

  render: ->
    $(@el).html(@template(title: @title))

    if @collection.models.length > 0
      @makeTitleActive()

      _.each(@collection.models, (model) =>
        @addDetail(model, false))
    @
    
  makeTitleActive: () ->
    if not @sectionIsActive
      $('.contact-card-section-title', @el)
        .css('color', '#000')
        .css('font-weight', 'bold')
        .css('font-style', 'normal')
        .css('display', 'block')

      @sectionIsActive = true

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
