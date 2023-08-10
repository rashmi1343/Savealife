import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "AIzaSyCcLgRIDZsVGKCMB-YHDiEMvhB-DDW6MR4"; //original key

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    print('Map Url:$url');
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    print("====================>>>>>>>>${values}");

    return values["routes"][0]["overview_polyline"]["points"];
  }
}
