import 'dart:async';

import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? icon;
  List<Marker> markers = [];
  CameraPosition kGooglePlex = const CameraPosition(target: LatLng(41.311081, 69.240562), zoom: 13.0);
  dynamic filter = {
    'distance': '1',
    'pointX': '41.311081',
    'pointY': '69.240562',
    'search': '',
  };

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
      final icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(12, 12),
            devicePixelRatio: 3.2,
          ),
          "images/user_marker.png");
      setState(() {
        filter['pointX'] = position.latitude.toString();
        filter['pointY'] = position.longitude.toString();
        markers.add(
          Marker(
            markerId: MarkerId(LatLng(position.latitude, position.longitude).toString()),
            position: LatLng(position.latitude, position.longitude),
            icon: icon,
          ),
        );
      });
      getPoses();
      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    }
  }

  getPoses() async {
    final response = await get('/services/mobile/api/pos-search', payload: filter);
    if (response != null && response.length > 0) {
      setState(() {
        markers = [];
      });
      for (var i = 0; i < response.length; i++) {
        // final Uint8List markerIcon = await getBytesFromCanvas(20, 20, image.bodyBytes);
        dynamic markerIcon;

        markerIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(50, 50),
              devicePixelRatio: 3.2,
            ),
            "images/map_icon.png");

        if (mounted) {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId(LatLng(response[i]['gpsPointX'], response[i]['gpsPointY']).toString()),
                position: LatLng(response[i]['gpsPointX'], response[i]['gpsPointY']),
                icon: response[i]['logoUrl'] != null ? BitmapDescriptor.fromBytes(markerIcon) : markerIcon,
                infoWindow: InfoWindow(
                  title: response[i]['name'],
                ),
              ),
            );
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPoses();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          compassEnabled: false,
          myLocationEnabled: true,
          mapToolbarEnabled: false,
          initialCameraPosition: kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          child: Container(
            child: SvgPicture.asset('images/icons/filter.svg'),
          ),
        ),
      ],
    );
  }
}
