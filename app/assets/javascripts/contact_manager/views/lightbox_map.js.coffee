class RippleApp.Views.LightboxMap extends Backbone.View
  template: JST['contact_manager/lightbox_map']
  
  initialize: ->
    @collection.on('add, remove', @render, this)
    @collection.on('reset', @render, this)
    @width = '400'
    @height = '40'
    @lat = '51.521472879353'
    @long = '-0.13312339782715'

  render: ->   
    length = @collection.length
    if length > 0
      @height = '150'
      set = @collection.pluck('default')
      included = _.include(set, true)
      if included == true
        _.each(@collection.models, (model) =>      
          if model.get('default') == true
            long = model.get('coordinates')[0]
            lat = model.get('coordinates')[1]
            @setMap(long, lat)
        )
      else
        first = @collection.at(0)
        if first        
          long = first.get('coordinates')[0]
          lat = first.get('coordinates')[1]
          @setMap(long, lat)
    #$(@el).html(@template(width: @width, height: @height, lat: @lat, long: @long))

    
    return this
    
  setMap: (long, lat) ->
    map = new OpenLayers.Map("expanded-map")
    

    
    #vectorLayer = new OpenLayers.Layer.Vector("Overlay")
    #feature = new OpenLayers.Feature.Vector(
    #  new OpenLayers.Geometry.Point(long, lat),
    #  {some:'data'},
    #  {externalGraphic: '/assets/images/tile.png', graphicHeight: 21, graphicWidth: 16}
    #)
    #vectorLayer.addFeatures(feature)
    
    console.log(map)
    arrayOSM = ["http://otile1.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.jpg",
                "http://otile2.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.jpg",
                "http://otile3.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.jpg",
                "http://otile4.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.jpg"]
    baseOSM = new OpenLayers.Layer.OSM("MapQuest-OSM Tiles", arrayOSM)
    mapnik = new OpenLayers.Layer.OSM('OpenStreetMap', 'http://a.tile.openstreetmap.org/${z}/${x}/${y}.png')
    fromProjection = new OpenLayers.Projection("EPSG:4326");   #Transform from WGS 1984
    toProjection = new OpenLayers.Projection("EPSG:900913"); #to Spherical Mercator Projection
    position = new OpenLayers.LonLat(long, lat).transform(fromProjection, toProjection)
    
    
    zoom = 15
    map.addLayer(baseOSM)
    markers = new OpenLayers.Layer.Markers("Markers")
    map.addLayer(markers)
    markers.addMarker(new OpenLayers.Marker(position))
    #size = new OpenLayers.Size(21,25)
    #offset = new OpenLayers.Pixel(-(size.w/2), -size.h)
    #icon = new OpenLayers.Icon('http://www.openlayers.org/dev/img/marker.png', size)
    #markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(-0.13312339782715, 51.521472879353),icon))
    #map.addLayer(vectorLayer)
    map.setCenter(position, zoom)
    
 