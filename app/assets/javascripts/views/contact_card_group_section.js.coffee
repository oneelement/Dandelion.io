class RippleApp.Views.ContactCardGroupSection extends Backbone.View
  template: JST['contact_manager/contact_card_hashtag_section']
  className: 'contact-card-hashtag-section'
  
  events:
    'keypress .subject_edit_view_input': 'checkEnter'

  initialize: ->
    @collection.on('add', @addDetail)
    @collection.on('remove', @renderRemove, this)
    @collection.on('reset', @clearDetails)
    @title = @options.title
    @icon = @options.icon
    @sectionIsActive = false
    @subject = @options.subject
    @subject.on('change', @render, this)
    @groups = RippleApp.contactsRouter.groups

  renderRemove: ->
    @clearDetails()
    if @collection.models.length > 0
      @makeTitleActive()

      _.each(@collection.models, (model) =>
        @addDetail(model, false))

  render: ->
    console.log('render group')
    $(@el).html(@template(title: @title, icon: @icon))
    
    group_ids = @subject.get('group_ids')
    
    console.log(group_ids)
    #@collection = new RippleApp.Collections.Groups()
    
    _.each(group_ids, (group_id) =>
      group = @groups.get(group_id)
      if group
        @collection.add(group)
    )
    
    console.log(@collection)


    #if @collection.models.length > 0
    #  @makeTitleActive()

      #_.each(@collection.models, (model) =>
      #  @addDetail(model, false))
    
    return this
    
  checkEnter: (event) ->
    #val = this.$('input.subject_edit_view_input').val()


    #if (event.keyCode == 13) 
      #event.preventDefault()
      #@closeEdit()
      
  closeEdit: ->
    type = this.$(".item-type option:selected").val()
    val = this.$('input.subject_edit_view_input').val()
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
    

  makeTitleActive: () ->
    if not @sectionIsActive
      this.$('.contact-card-section-title').addClass('active')
      @sectionIsActive = true
    else
      if this.$('.contact-card-section-title').hasClass('active')
      else
        this.$('.contact-card-section-title').addClass('active')  

  buildDetailEl: (model) =>
    return $(new RippleApp.Views.ContactCardGroupDetail(
      model: model
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
