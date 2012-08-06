class RippleApp.Views.ContactCardMap extends Backbone.View
  template: JST['contact_manager/contact_card_map']
  id: 'map-placeholder'
  
  initialize: ->
    @collection.on('add, remove', @render, this)
    @collection.on('reset', @render, this)
    @source = 'http://ojw.dev.openstreetmap.org/StaticMap/?lat=51.521472879353&amp;lon=-0.13312339782715&amp;z=16&amp;w=400&amp;h=50&amp;filter=lightgrey&amp;mode=Export&amp;att=none&amp;show=1" width="400" height="50" alt="OpenStreetMap (mapnik) map of the area around 51.52147, -0.13312'
    console.log(@collection)
    @width = '400'
    @height = '180'
    @lat = '51.521472879353'
    @long = '-0.13312339782715'

  render: ->
    length = @collection.length
    if length > 0
      $(this.el).addClass('map-present')
      @height = '180'
      set = @collection.pluck('default')
      included = _.include(set, true)
      if included == true
        _.each(@collection.models, (model) =>      
          if model.get('default') == true
            @long = model.get('coordinates')[0]
            @lat = model.get('coordinates')[1]
        )
      else
        first = @collection.at(0)
        if first        
          @long = first.get('coordinates')[0]
          @lat = first.get('coordinates')[1]

    $(@el).html(@template(width: @width, height: @height, lat: @lat, long: @long))
    
    return this
    
 