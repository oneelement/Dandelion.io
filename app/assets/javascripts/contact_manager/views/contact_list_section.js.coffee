class RippleApp.Views.ContactListSection extends Backbone.View
  template: JST['contact_manager/contact_list_section']
  className: 'contact-list-section'

  initialize: ->
    @collection.on('add', @render, this)
    @collection.on('reset', @render, this)


  render: ->
    $(@el).html(@template())
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
    
 