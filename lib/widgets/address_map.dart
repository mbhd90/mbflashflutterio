import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import "package:latlong2/latlong.dart";
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddressMap extends StatefulWidget {
    final LatLng position;
    
    const AddressMap ({ Key? key, 
    required this.position }): super(key: key);

    @override
    State<StatefulWidget> createState() => AddressMapState();
} 

class AddressMapState extends State<AddressMap>
    with AutomaticKeepAliveClientMixin, OSMMixinObserver{
    late MapController controller;
    late GeoPoint geoPoint;

    @override
    void initState(){
        super.initState(); 
    }
    @override
    Future<void> mapIsReady(bool isReady) async {
      if (isReady) {
        /// put you logic
        print("Map ready!");
        await controller.addMarker(GeoPoint(latitude: widget.position.latitude, longitude: widget.position.longitude));
        
      }
    }

    @override
    Future<void> mapRestored() async {
        super.mapRestored();
        /// TODO
    }
        //etc
    
    @override
    @mustCallSuper
    Widget build(BuildContext context) {
        print("Loading:: position");
        print(widget.position);
        controller = MapController(
            initMapWithUserPosition: false,
            initPosition: GeoPoint(latitude: widget.position.latitude, longitude: widget.position.longitude),
        );
        controller.addObserver(this);
        super.build(context);
        return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(height: 30),
                Container(
                    height: 200, 
                    color: Colors.blue,
                    child: OSMFlutter(
                        controller: controller,
                        trackMyPosition: false,
                        initZoom: 18,
                        minZoomLevel: 12,
                        maxZoomLevel: 19,
                        stepZoom: 1.0,
                        userLocationMarker: UserLocationMaker(
                            personMarker: MarkerIcon(
                                icon: Icon(
                                    Icons.location_history_rounded,
                                    color: Colors.red,
                                    size: 100,
                                ),
                            ),
                            directionArrowMarker: MarkerIcon(
                                icon: Icon(
                                    Icons.double_arrow,
                                    size: 100,
                                ),
                            ),
                        ),
                        /*road: Road(
                                startIcon: MarkerIcon(
                                icon: Icon(
                                    Icons.person,
                                    size: 64,
                                    color: Colors.brown,
                                ),
                                ),
                                roadColor: Colors.yellowAccent,
                        ),*/
                        markerOption: MarkerOption(
                            defaultMarker: MarkerIcon(
                                icon: Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                                size: 100,
                                ),
                            )
                        )
                    ),
                ),
                SizedBox(height: 30)
            ]
        );
    }
    
    @override
    bool get wantKeepAlive => true;
}