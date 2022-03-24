import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class geocodeRequest {
  static Future<String> geolocationToAddress(latlngPosition) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latlngPosition.latitude},${latlngPosition.longitude}&key=AIzaSyCsnujoiLStcDjAxK4Ier7paGsTxifP2Y4'),
    );
    if (response.statusCode == 200) {
      var decodeData = jsonDecode(response.body);
      return decodeData['results'][0]['formatted_address'];
    }
  }

  static Future<String> geolocationPostcodetoCity(postcode) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${postcode}&key=AIzaSyCsnujoiLStcDjAxK4Ier7paGsTxifP2Y4'),
    );
    if (response.statusCode == 200) {
      var decodeData = jsonDecode(response.body);
      return decodeData['results'][0]['address_components'][2]['long_name']
              .toString() +
          ', ' +
          decodeData['results'][0]['address_components'][3]['long_name']
              .toString();
    }
  }

  static Future<List<String>> geolocationPostcodetolatlng(postcode) async {
    List<String> latlng = [];
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${postcode}&key=AIzaSyCsnujoiLStcDjAxK4Ier7paGsTxifP2Y4'),
    );
    if (response.statusCode == 200) {
      var decodeData = jsonDecode(response.body);
      latlng.add(
          decodeData['results'][0]['geometry']['location']['lat'].toString());
      latlng.add(
          decodeData['results'][0]['geometry']['location']['lng'].toString());
      return latlng;
    }
  }
}
