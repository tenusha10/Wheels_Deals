import 'dart:convert';
import 'package:http/http.dart' as http;

class distanceMatrix {
  static Future<dynamic> getDistance(String destinationLat,
      String destinationLng, String originLat, String originLng) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${destinationLat},${destinationLng}&origins=${originLat},${originLng}&units=imperial&key=AIzaSyCsnujoiLStcDjAxK4Ier7paGsTxifP2Y4&travelMode=DRIVING'),
    );
    if (response.statusCode == 200) {
      var decodeData = jsonDecode(response.body);
      //return decodeData['rows'][0]['elements'][0]['distance']['text']
      // .toString();
      return decodeData;
    }
  }
}
