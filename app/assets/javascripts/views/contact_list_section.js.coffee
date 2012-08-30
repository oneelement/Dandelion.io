class RippleApp.Views.ContactListSection extends Backbone.View
  template: JST['contact_manager/contact_list_section']
  className: 'contact-list-section'

  initialize: ->
    @collection.on('add, remove', @render, this)
    @collection.on('reset', @render, this)
    @title = @options.title
    if @options.subject
      @subject = @options.subject
      #@subject.on('change', @render, this)
    if @options.groups
      @groups = @options.groups
      @groups.on('remove', @renderRemove, this)
    if @options.hashes
      @hashes = @options.hashes
      @hashes.on('add, remove, reset', @render, this)
      #console.log(@hashes)
      
  renderRemove: ->
    $(this.el).empty()
    if @groups.models.length > 0
      _.each(@groups.models, (model) =>
        view = new RippleApp.Views.ContactCardHashtagDetail(model: model, subject: @subject, collection: @collection)
        $(this.el).append(view.render().el)
      )

  render: =>
    $(@el).html(@template())
    if @title == 'Hashtags'
      #console.log('contacts list section render')
      _.each(@collection.models, (model) =>      
        view = new RippleApp.Views.ContactCardHashtagDetail(model: model, subject: @subject, collection: @collection)
        $(this.el).append(view.render().el)
      )
    else if @title == 'Groups'
      _.each(@groups.models, (model) =>      
        view = new RippleApp.Views.ContactCardGroupDetail(model: model, subject: @subject, collection: @groups)
        $(this.el).append(view.render().el)
      )
    else
      length = @collection.length
      set = @collection.pluck('default')
      included = _.include(set, true)
      if included == true
        _.each(@collection.models, (model) =>      
          if model.get('default') == true
            view = new RippleApp.Views.ContactListDetail(model: model)
            $(this.el).append(view.render().el)
        )
      else
        first = @collection.at(0)
        if first
          view = new RippleApp.Views.ContactListDetail(model: first)
          $(this.el).append(view.render().el)
      
    return this
    
 