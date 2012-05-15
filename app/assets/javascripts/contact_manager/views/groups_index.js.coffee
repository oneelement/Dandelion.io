class RippleApp.Views.GroupsIndex extends Backbone.View
  template: JST['contact_manager/groups/group_index']
  id: 'groups-index'
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendGroup)
    this.$('#groups-table').dataTable("bPaginate": false, "oLanguage": {sSearch: ""}, "bInfo": false, "aaSorting": [ [1,'asc'] ])
    return this
    
  appendGroup: (group) =>
    console.log(group)
    view = new RippleApp.Views.GroupsList(model: group)
    #@$el.append(view.render().el)
    this.$('#groups-table-body').append(view.render().el)
