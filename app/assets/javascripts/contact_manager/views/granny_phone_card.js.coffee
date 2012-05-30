class RippleApp.Views.GrannyPhoneCard extends Backbone.View
  template: JST['contact_manager/granny_phone_card']
  subTemplate: JST['contact_manager/granny_phone_card_item']

  render: ->
    $(@el).html(@template(model: {id: 'granny-phone-card'}))
    _.each(@collection.models, (model) =>
      if model.get('_type') == 'PhoneMobile'
        model.set('icon', '!')
      if model.get('_type') == 'PhoneHome'
        model.set('icon', '"')
      console.log(model.toJSON())
      $('#granny-phone-card', @el).append(@subTemplate(model: model.toJSON()))
    )
    @
