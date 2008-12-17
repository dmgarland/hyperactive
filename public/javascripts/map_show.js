        
        var map; //complex object of type OpenLayers.Map
        var markers; // this is where we store the marker.
        var targetmarker; // object representing the (single) target marker.

        //Initialise the 'map' object
        function mapinit() {

            if ($("xlon").getValue()){
              // Extract available values from form
              var lon= Number($("xlon").getValue());
		  var lat= Number($("xlat").getValue());
              var zoom= Number($("xres").getValue());
            }
            else {
              // This is London!
              var lat=51.508;
              var lon=-0.118;
              var zoom=13;
            }

            
            map = new OpenLayers.Map ("map", {
                controls:[
                    new OpenLayers.Control.Navigation(),
                    new OpenLayers.Control.PanZoomBar()
                    // , new OpenLayers.Control.Attribution()
                    ],
                maxExtent: new OpenLayers.Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34),
                maxResolution: 156543.0399,
                numZoomLevels: 19,
                units: 'm',
                projection: new OpenLayers.Projection("EPSG:900913"),
                displayProjection: new OpenLayers.Projection("EPSG:4326")
            } );


            // Define the map layer
            // 3 layers provided
            layerTilesAtHome = new OpenLayers.Layer.OSM.Mapnik("Mapnik");
            map.addLayer(layerTilesAtHome);
		OSlayerTilesAtHome = new OpenLayers.Layer.OSM.Osmarender("Osmarender");
            map.addLayer(OSlayerTilesAtHome);
		CyclayerTilesAtHome = new OpenLayers.Layer.OSM.CycleMap("CycleMap")
            map.addLayer(CyclayerTilesAtHome);
            map.addControl( new OpenLayers.Control.LayerSwitcher() );

            // Marker layer
            markers = new OpenLayers.Layer.Markers( "Markers" );
            map.addLayer(markers);

            // Centre map & add location mark
            var lonLat = new OpenLayers.LonLat(lon, lat).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
            map.setCenter (lonLat, zoom);
            
            // Put a market down there
            if ($("xlon").getValue()){
                    var size = new OpenLayers.Size(20,34);
                    var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
                    var icon = new OpenLayers.Icon('/images/open_street_map_marker.png',size,offset);
                    targetmarker = new OpenLayers.Marker(new OpenLayers.LonLat(lonLat.lon,lonLat.lat),icon);
                    markers.addMarker(targetmarker);
            }

        }

