import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:wheels_deals/Googlemaps_requests/embedMaps.dart';
import 'package:wheels_deals/Googlemaps_requests/geocodeRequest.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as sMaps;

class SearchCars extends StatefulWidget {
  @override
  State<SearchCars> createState() => _SearchCarsState();
}

class _SearchCarsState extends State<SearchCars> {
  LatLng latlngPosition;
  Location location = new Location();
  Future<LocationData> locationget() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location not enabled');
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Permission not granted');
      }
    }
    return _locationData = await location.getLocation();
  }

  void locatePosition() async {
    //Position position = await _determinePosition();
    print('ye');
    LocationData l = await locationget();
    latlngPosition = LatLng(l.latitude, l.longitude);
    print(latlngPosition.latitude.toString() +
        "  " +
        latlngPosition.longitude.toString());
    //String g = await geocodeRequest.geolocationToAddress(latlngPosition);
    String c = await geocodeRequest.geolocationPostcodetoCity('de214ue');
    print(c);
  }

  void ll() async {
    String c = await geocodeRequest.geolocationPostcodetoCity('SW1A 2AA');
    print(c);
  }

  @override
  Widget build(BuildContext context) {
    sMaps.StaticMapController _controller = sMaps.StaticMapController(
        width: 300,
        height: 300,
        googleApiKey: 'AIzaSyCsnujoiLStcDjAxK4Ier7paGsTxifP2Y4',
        zoom: 10,
        center: sMaps.Location(-3.1694166, -60.1041517));
    ImageProvider image = _controller.image;
    return Container(
        child: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              ll();
            },
            child: Text('Press ME')),
        ElevatedButton(
            onPressed: () async {
              locatePosition();
            },
            child: Text('Press ME')),
        SizedBox(
          height: 100,
        ),
        Image(image: image)
      ],
    ));
  }
}
