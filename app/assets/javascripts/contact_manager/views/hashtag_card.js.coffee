class RippleApp.Views.HashtagCard extends Backbone.View
  template: JST['contact_manager/hashtag_card']
  id: 'hashtag-card'
    
  #events:

  #initialize: ->
    
  render: ->
    $(@el).html(@template(hashtag: @model.toJSON()))
    @