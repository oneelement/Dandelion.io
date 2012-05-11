class RippleApp.Views.ContactCardSection extends Backbone.View
  template: JST['contact_manager/contact_card_section']
  className: 'contact-card-section'

  initialize: ->
    @collection.on('add', @addDetail)
    @collection.on('reset', @clearDetails)
    @title = @options.title
    @sectionIsActive = false

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

      @sectionIsActive = true

  buildDetailEl: (model) =>
    return $(new RippleApp.Views.ContactCardDetail(
      model: model
      icon: model.getViewIcon()
      value: model.getViewValue()
    ).render().el)

  clearDetails: =>
    $detailsList = $('.contact-details-list', @el).empty()

  addDetail: (model, animate) =>
    $detailsList = $('.contact-details-list', @el)
    $detailEl = @buildDetailEl(model)

    if animate
      $detailEl.css('display', 'none')

    #console.log($detailEl)

    $detailsList.append($detailEl)
    @makeTitleActive()

    if animate
      $detailEl.fadeIn(500)
