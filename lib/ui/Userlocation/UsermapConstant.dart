import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

void createRoute(
    String encondedPoly, LatLng startLocation, Set<Polyline> polyLines) {
  polyLines.add(Polyline(
      polylineId: PolylineId(startLocation.toString()),
      width: 4,
      points: _convertToLatLng(_decodePoly(encondedPoly)),
      color: Color.fromARGB(255, 141, 15, 6)));
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

List _decodePoly(String poly) {
  var list = poly.codeUnits;
  var lList = [];
  int index = 0;
  int len = poly.length;
  int c = 0;
  do {
    var shift = 0;
    int result = 0;

    do {
      c = list[index] - 63;
      result |= (c & 0x1F) << (shift * 5);
      index++;
      shift++;
    } while (c >= 32);
    if (result & 1 == 1) {
      result = ~result;
    }
    var result1 = (result >> 1) * 0.00001;
    lList.add(result1);
  } while (index < len);

  for (var i = 2; i < lList.length; i++) {
    lList[i] += lList[i - 2];
  }

  print(lList.toString());

  return lList;
}

List<LatLng> _convertToLatLng(List points) {
  List<LatLng> result = <LatLng>[];
  for (int i = 0; i < points.length; i++) {
    if (i % 2 != 0) {
      result.add(LatLng(points[i - 1], points[i]));
    }
  }
  return result;
}
