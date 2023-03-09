import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constant.dart';

class PohonkuMaps extends StatefulWidget{
  const PohonkuMaps({Key? key}) : super(key: key);

  @override
  State<PohonkuMaps> createState() => _PohonkuMapsStateDetail();
}

class _PohonkuMapsStateDetail extends State<PohonkuMaps> {

  GoogleMapController? mapController;
  Set<Marker> markers = Set();
  late LatLng showLocation;

  @override
  void initState() {
    showLocation = LatLng(-6.200000, 106.816666);
    markers.add(Marker(
      markerId: MarkerId(showLocation.toString()),
      position: showLocation,
      // infoWindow: InfoWindow(
      //   title: 'Lokasi',
      //   snippet: Address,
      // ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              titlePohonAndalan,
            ),
            Visibility(
              visible: true,
              child: Text(
                "Lokasi Penanaman",
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
          ],
        ),
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: showLocation,
          zoom: 18.0,
        ),
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}