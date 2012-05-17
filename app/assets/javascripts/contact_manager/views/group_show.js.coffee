class RippleApp.Views.GroupShow extends Backbone.View
  template: JST['contact_manager/groups/group_show']
  className: 'group-show'
  
  initialize: ->
    @model.on('change', @render, this)
    @user = @options.user
    console.log(@user)

  render: ->
    $(@el).html(@template(group: @model.toJSON())) 
    return this
    
