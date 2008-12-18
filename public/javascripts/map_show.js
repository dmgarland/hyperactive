function goatmap(divname, isshow){

    // Store the name of the DIV
    this.divname = divname;
    this.isshow = isshow;

    var map; //complex object of type OpenLayers.Map
    var markers; // this is where we store the marker.
    var targetmarker; // object representing the (single) target marker.


            // Make a click event router
            OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {                
                defaultHandlerOptions: {
                    'single': true,
                    'double': false,
                    'pixelTolerance': 0,
                    'stopSingle': false,
                    'stopDouble': false
                },

                initialize: function(options) {
                    this.handlerOptions = OpenLayers.Util.extend(
                        {}, this.defaultHandlerOptions
                    );
                    OpenLayers.Control.prototype.initialize.apply(
                        this, arguments
                    ); 
                    this.handler = new OpenLayers.Handler.Click(
                        this, {
                            'click': this.trigger
                        }, this.handlerOptions
                    );
                }, 

                trigger: function(e) {
                    // Extract coordinates in projection space
                    var lonlat = map.getLonLatFromViewPortPx(e.xy);

                    // Get points in "real" coordinates & store those
                    var lonLatOutside = lonlat.clone();
                    lonLatOutside.transform(map.getProjectionObject(), new OpenLayers.Projection("EPSG:4326"));

                    $("xlon").value = lonLatOutside.lon;
			              $("xlat").value = lonLatOutside.lat;
                    $("xres").value = map.getZoom();

                    // Update the marker in projection coordinates
                    __mapupdate(lonlat.lon,lonlat.lat);

                }

            });

        var __mapupdate = function(lon, lat) {
           // Update the marker in projection coordinates
           if (targetmarker){
              markers.removeMarker(targetmarker); }
           var size = new OpenLayers.Size(20,34);
           var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
           var icon = new OpenLayers.Icon('/images/open_street_map_marker.png',size,offset);
           // Save the target marker so that we can delete it later
           targetmarker = new OpenLayers.Marker(new OpenLayers.LonLat(lon,lat),icon);
           markers.addMarker(targetmarker);

           var lonLat = new OpenLayers.LonLat(lon, lat)
           map.setCenter (lonLat, map.getZoom());


        }

        // Register the function with the object!
        this.mapupdate = __mapupdate;

        //Initialise the 'map' object
        this.mapinit = function() {

            if ($("xlon") && $("xlon").getValue()){
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

            
            map = new OpenLayers.Map (this.divname, {
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
            if ($("xlon") && $("xlon").getValue()){
                    this.mapupdate(lonLat.lon,lonLat.lat);
            }

            if (this.isshow){
               // Register the click event
               var click = new OpenLayers.Control.Click();
               map.addControl(click);
               click.activate();
            }
        }

      // Do initialise by default
	this.mapinit();
}