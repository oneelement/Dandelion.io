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
    @subjectCollection = @options.subjectCollection
    #@subject.on('change', @render, this)  #re-renders on subject change to fetch extra values form server
    @modelName = @options.modelName
    @dummyModel = new @modelName
    @types = @dummyModel.getTypes()
    @modelType = @dummyModel.getModelType()
    @fieldName = @dummyModel.getFieldName()
    @source = 'contact_user'
    @subjectName = @subject.getModelName()

  render: ->
    console.log('contact user card section render')
    #$(@el).html(@template(title: @title, icon: @icon, types: @types, modelType: @modelType, source: @source))

    @setCollection()
    @deleteRemovedItems()
    
    #if @collection.models.length > 0
    #  _.each(@collection.models, (model) =>
    #    @addDetail(model, false))
    
    return this
    
  setCollection: =>
    console.log('set collection')
    if @collection.models.length > 0
      save = false
      _.each(@collection.models, (model) =>
        console.log(model)
        id = model.get('_id')
        match = false
        _.each(@subjectCollection.models, (subcol) =>
          parent = subcol.get('parent_id')
          console.log(parent)
          console.log(id)
          console.log('broke')
          if parent == id
            console.log('existing')
            match = true
            value = subcol.get(@fieldName)
            parent_value = model.get(@fieldName)
            if parent_value != value
              subcol.set(@fieldName, parent_value)   
              save = true
              subcol.save(null, { silent: true })
        )
        console.log(match)
        if match == false
          subject_item = new @modelName
          parent_value = model.get(@fieldName)
          parent_type = model.get('_type')
          parent_id = model.get('_id')
          subject_item.set('parent_id', parent_id)
          subject_item.set(@fieldName, parent_value)
          subject_item.set('_type', parent_type)
          subject_id = @subjectName + "_id"
          subject_item.set(subject_id, @subject.get('_id'))
          @subjectCollection.add(subject_item)
          console.log(subject_item)
          console.log(parent_value)
          console.log(@subjectCollection)
          save = true
          subject_item.save(null, { silent: true })
      )
      #if save == true
        #@subject.save(null, { silent: true })
  
  deleteRemovedItems: =>
    subject_parent_ids = @subjectCollection.pluck('parent_id')
    filtered_subject_parent_ids = []
    _.each(subject_parent_ids, (id) =>
      if id != null
        filtered_subject_parent_ids.push(id)
    )
    parent_ids = @collection.pluck('_id')
    diff = _.difference(filtered_subject_parent_ids, parent_ids )
    console.log(filtered_subject_parent_ids)
    console.log(parent_ids)
    console.log(@modelType)
    console.log(diff)
    if diff
      _.each(diff, (id) =>
        console.log(id)        
        delete_item = @subjectCollection.where(parent_id: id)
        item = delete_item[0]
        console.log(delete_item)
        console.log(item)
        item.destroy()
      )
    
  buildDetailEl: (model) =>
    return $(new RippleApp.Views.ContactUserDetail(
      model: model
      icon: model.getViewIcon()
      value: model.getViewValue()
      collection: @collection
      subject: @subject
      source: @source
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
