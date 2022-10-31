import 'dart:async';

import 'package:control_car_client/components/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:control_car_client/helpers/api.dart';
import 'package:control_car_client/helpers/helper.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? controller;
  BitmapDescriptor? icon;
  dynamic token = '';

  List<Marker> markers = [];
  List<LatLng>? polygonCoords = [];

  CameraPosition kGooglePlex = const CameraPosition(target: LatLng(41.311081, 69.240562), zoom: 13.0);
  dynamic filter = {
    'distance': '20',
    'pointX': '',
    'pointY': '',
    'search': '',
  };
  dynamic animate = true;

  dynamic distance = [
    {
      'name': '1.0 km',
      'value': 1,
      'select': false,
    },
    {
      'name': '2.0 km',
      'value': 2,
      'select': false,
    },
    {
      'name': '5.0 km',
      'value': 5,
      'select': false,
    },
    {
      'name': '10.0 km',
      'value': 10,
      'select': false,
    },
    {
      'name': '20.0 km',
      'value': 20,
      'select': false,
    },
  ];

  void getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.deniedForever && permission != LocationPermission.denied) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final GoogleMapController controller = await _controller.future;
      dynamic newPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      );
      setState(() {
        filter['pointX'] = position.latitude.toString();
        filter['pointY'] = position.longitude.toString();
      });
      getPoses();
      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    }
  }

  Set<Polygon> myPolygon() {
    setState(() {
      polygonCoords!.add(LatLng(double.parse(filter['pointX']), double.parse(filter['pointY'])));
      polygonCoords!.add(const LatLng(37.43296265331129, -122.08832357078792));
    });
    Set<Polygon> polygonSet = {};
    polygonSet.add(Polygon(polygonId: const PolygonId('test'), points: polygonCoords!, strokeColor: green));
    return polygonSet;
  }

  getPoses({search = false}) async {
    final response = await get('/services/mobile/api/pos-search', payload: filter, guest: true);
    if (response != null && response.length > 0) {
      setState(() {
        markers = [];
      });
      for (var i = 0; i < response.length; i++) {
        if (mounted) {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId(LatLng(response[i]['gpsPointX'], response[i]['gpsPointY']).toString()),
                position: LatLng(response[i]['gpsPointX'], response[i]['gpsPointY']),
                infoWindow: InfoWindow(
                  title: response[i]['name'],
                ),
              ),
            );
          });
        }
      }
      controller = await _controller.future;
      if (markers.length == 1) {
        dynamic newPosition = CameraPosition(
          target: LatLng(response[0]['gpsPointX'], response[0]['gpsPointY']),
          zoom: 17,
        );
        controller = await _controller.future;
        controller!.animateCamera(CameraUpdate.newCameraPosition(newPosition));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPoses();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SimpleAppBar(
            padding: EdgeInsets.zero,
            appBar: AppBar(),
            title: 'Xarita',
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.terrain,
                  compassEnabled: false,
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  initialCameraPosition: kGooglePlex,
                  // polygons: myPolygon(),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(markers),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              getCurrentLocation();
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradient,
              ),
              child: const Icon(Icons.my_location),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Container(
            color: Colors.transparent,
            height: 45,
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.only(bottom: 24),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    filter['search'] = '';
                  });
                  getPoses(search: true);
                }
                if (value.length >= 3) {
                  setState(() {
                    filter['search'] = value;
                  });
                  getPoses(search: true);
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF9CA4AB),
                ),
                hintText: 'izlash...',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA4AB),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFE3E9ED),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFE3E9ED),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                fillColor: white,
                filled: true,
              ),
            ),
          ),
        ),
        !animate
            ? AnimatedContainer(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.4),
                duration: const Duration(milliseconds: 800),
                onEnd: () {},
              )
            : Container(),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
          top: MediaQuery.of(context).size.height * 0.37,
          right: animate ? -290 : -10,
          child: Container(
            width: 300,
            height: 250,
            padding: const EdgeInsets.only(top: 24, bottom: 24, left: 24),
            decoration: BoxDecoration(
              color: white,
              border: Border.all(
                color: const Color(0XFF83B6D5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(61, 112, 143, 0.7),
                  spreadRadius: -5,
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        'Masofa:',
                        style: TextStyle(
                          color: Color(0XFF3D708F),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Wrap(
                      children: [
                        for (var i = 0; i < distance.length; i++)
                          GestureDetector(
                            onTap: () {
                              for (var k = 0; k < distance.length; k++) {
                                setState(() {
                                  distance[k]['select'] = false;
                                });
                              }
                              distance[i]['select'] = true;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              margin: const EdgeInsets.only(bottom: 12, right: 12),
                              decoration: BoxDecoration(
                                color: distance[i]['select'] ? const Color(0xFF00AF50) : const Color(0XFFE7EEF9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                distance[i]['name'],
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: GestureDetector(
                    onTap: () {
                      for (var k = 0; k < distance.length; k++) {
                        if (distance[k]['select']) {
                          setState(() {
                            filter['distance'] = distance[k]['value'].toString();
                            animate = !animate;
                          });
                          getPoses();
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Qidirish',
                        style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 900),
          curve: Curves.fastOutSlowIn,
          top: MediaQuery.of(context).size.height * 0.35,
          right: animate ? 0 : 270,
          child: GestureDetector(
            onTap: () {
              setState(() {
                animate = !animate;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF3D708F),
                    spreadRadius: -5,
                    blurRadius: 30,
                    offset: Offset(0, 10), // changes position of shadow
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'images/icons/filter.svg',
                width: 16,
                height: 16,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
