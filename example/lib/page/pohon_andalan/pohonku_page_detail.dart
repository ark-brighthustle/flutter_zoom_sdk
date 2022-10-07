import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constant.dart';

class PohonPageDetail extends StatefulWidget{
  final String lat, lng, nama, deskripsi, timestamps;
  const PohonPageDetail({Key? key, required this.lat, required this.lng, required this.nama, required this.deskripsi, required this.timestamps}) : super(key: key);

  @override
  State<PohonPageDetail> createState() => _PohonPageDetailStateDetail();
}

class _PohonPageDetailStateDetail extends State<PohonPageDetail> {

  GoogleMapController? mapController;
  Set<Marker> markers = Set();
  late LatLng showLocation;

  @override
  void initState() {
    showLocation = LatLng(double.parse(widget.lat), double.parse(widget.lng));
    markers.add(Marker(
      markerId: MarkerId(showLocation.toString()),
      position: showLocation,
      // infoWindow: InfoWindow(
      //   title: 'Lokasi',
      //   snippet: Address,
      // ),
      onTap: () {
        _bottomSheet();
      },
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
                "Pohonku",
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

  _bottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (_) {
          return SizedBox(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Container(
                            height: 8.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.all(const Radius.circular(80.0))))
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(23.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nama Pohon", style: TextStyle(color: Colors.black),),
                              Text(widget.nama, style: const TextStyle(fontWeight: FontWeight.w600,),)
                            ],
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Usia Tanam", style: TextStyle(color: Colors.black,),),
                              Text(widget.timestamps, style: const TextStyle(fontWeight: FontWeight.w600,),)
                            ],
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Keterangan", style: TextStyle(color: Colors.black,),),
                              Text(widget.deskripsi, style: const TextStyle(fontWeight: FontWeight.w600,),)
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Padding(padding: const EdgeInsets.only(right: 12.0),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Padding(padding: const EdgeInsets.only(bottom: 8.0),
                        //             child: SizedBox(
                        //               width: 100,
                        //               height: 100,
                        //               child: ClipRRect(
                        //                   borderRadius: BorderRadius.circular(12),
                        //                   child: Image.network(
                        //                     "https://ichef.bbci.co.uk/images/ic/960x960/p08634k6.jpg",
                        //                     fit: BoxFit.cover,
                        //                     errorBuilder: (context, error, stackTrace) {
                        //                       return Container(
                        //                           alignment: Alignment.center,
                        //                           child: Column(
                        //                             mainAxisAlignment: MainAxisAlignment.center,
                        //                             children: const [
                        //                               Icon(
                        //                                 Icons.broken_image,
                        //                                 size: 90,
                        //                                 color: kGrey,
                        //                               ),
                        //                             ],
                        //                           ));
                        //                     },
                        //                   )),
                        //             ),
                        //           ),
                        //           Text("Awal Tanam", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                        //         ],
                        //       ),
                        //     ),
                        //     Padding(padding: const EdgeInsets.only(right: 12.0),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Padding(padding: const EdgeInsets.only(bottom: 8.0),
                        //             child: SizedBox(
                        //               width: 100,
                        //               height: 100,
                        //               child: ClipRRect(
                        //                   borderRadius: BorderRadius.circular(12),
                        //                   child: Image.network(
                        //                     "https://ichef.bbci.co.uk/images/ic/960x960/p08634k6.jpg",
                        //                     fit: BoxFit.cover,
                        //                     errorBuilder: (context, error, stackTrace) {
                        //                       return Container(
                        //                           alignment: Alignment.center,
                        //                           child: Column(
                        //                             mainAxisAlignment: MainAxisAlignment.center,
                        //                             children: const [
                        //                               Icon(
                        //                                 Icons.broken_image,
                        //                                 size: 90,
                        //                                 color: kGrey,
                        //                               ),
                        //                             ],
                        //                           ));
                        //                     },
                        //                   )),
                        //             ),
                        //           ),
                        //           Text("4 Hari", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                        //         ],
                        //       ),
                        //     ),
                        //     Padding(padding: const EdgeInsets.only(right: 12.0),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Padding(padding: const EdgeInsets.only(bottom: 8.0),
                        //             child: SizedBox(
                        //               width: 100,
                        //               height: 100,
                        //               child: ClipRRect(
                        //                   borderRadius: BorderRadius.circular(12),
                        //                   child: Image.network(
                        //                     "https://ichef.bbci.co.uk/images/ic/960x960/p08634k6.jpg",
                        //                     fit: BoxFit.cover,
                        //                     errorBuilder: (context, error, stackTrace) {
                        //                       return Container(
                        //                           alignment: Alignment.center,
                        //                           child: Column(
                        //                             mainAxisAlignment: MainAxisAlignment.center,
                        //                             children: const [
                        //                               Icon(
                        //                                 Icons.broken_image,
                        //                                 size: 90,
                        //                                 color: kGrey,
                        //                               ),
                        //                             ],
                        //                           ));
                        //                     },
                        //                   )),
                        //             ),
                        //           ),
                        //           Text("2 Bulan 24 Hari", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ]),
          );
        });
  }
}