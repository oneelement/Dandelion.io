class RippleApp.Views.ContactCardGroupDetail extends Backbone.View
  template: JST['contact_manager/contact_details/hashtag_detail']
  className: 'contact-hashtag-detail'
  
  events:
    'dblclick span.contact-detail-value': 'editValue'
    'keypress #edit_value': 'checkEnter'
    'click span.edit-icon': 'editValue'
    'click span.contact-detail-remove-hashtag': 'deleteValue'
    'focusout input#edit_value': 'closeEdit'
    
    'hover .contact-detail-remove-hashtag': 'removeHover'
    'click .contact-detail-value': 'showGroup'

  initialize: ->
    @value = @model.get('name')
    @model.on('change', @render, this)
    @subject = @options.subject
    @modelType = @model.getModelName()
    @subjectType = @subject.getModelName()
    $(@el).addClass(@modelType)

  render: ->
    $(@el).html(@template(value: @value, detail: @model.toJSON()))
    
    return this
    
    
  showGroup: ->
    Backbone.history.navigate('groups/show/' + @model.id, true)
    
 
  editValue: ->
    $(this.el).addClass('editing')
    this.$('input#edit_value').focus()
    this.$('span.edit-icon').css('display', 'block')
    
  deleteValue: =>
    @collection.remove(@model)
    groups = @subject.get('group_ids')
    index = _.indexOf(groups, @model.get('_id'))
    groups.splice(index, 1)
    @subject.set('group_ids', groups, { silent: true })
    @subject.save()
    if @subjectType == 'contact'
      group_contacts = @model.get('contact_ids')
      index = _.indexOf(group_contacts, @subject.get('_id'))
      group_contacts.splice(index, 1)
      @model.set('contact_ids', group_contacts, { silent: true })
      @model.save(null, { silent: true })
    else if @subjectType == 'group'
      group_groups = @model.get('group_ids')
      index = _.indexOf(group_groups, @subject.get('_id'))
      group_groups.splice(index, 1)
      @model.set('group_ids', group_groups, { silent: true })
      @model.save(null, { silent: true })
  
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      @closeEdit()
      
  closeEdit: ->
    value = @model.getFieldName()
    this.model.set(value, this.$('input#edit_value').val())
    $(this.el).removeClass('editing')
    this.$('span.edit-icon').css('display', 'none')
    
  removeHover: ->
    $(this.el).toggleClass('remove')
