import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/bloc/SendHelpBloc/send_help_bloc.dart';
import 'package:savealifedemoapp/ui/Medical/MedicalCategories.dart';
import 'package:savealifedemoapp/ui/Medical/NearByPlaces.dart';
import 'package:savealifedemoapp/ui/Userlocation/mapRequest.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../Model/GetAllUsersResponse.dart';
import '../../Model/Help/GetRouteForMapResponse.dart';
import '../../Model/Help/SendHelpRequestModel.dart';
import '../../bloc/User_bloc/user_bloc.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../GetHelpFrom/GetHelpMenuPage.dart';
import '../NavigationBar/fab_bottom_app_bar.dart';
import '../NavigationBar/layout.dart';
import 'NearByPlacesResponse.dart';

class NearByMapRoute extends StatefulWidget {
  String accesstoken;
  String title;

  List<Results> placeslist;

  NearByMapRoute({
    super.key,
    required this.accesstoken,
    required this.title,
    required this.placeslist,
  });

  @override
  _NearByMapRouteState createState() => _NearByMapRouteState();
}

class _NearByMapRouteState extends State<NearByMapRoute> {
  late GoogleMapController mapController; //contrller for Google map

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {};
  double sourcelat = 28.628151;
  double sourcelong = 77.367783;
  Geometry? geometry;
  double distance = 0.0;
  final CustomInfoWindowController _sourcecustomInfoWindowController =
      CustomInfoWindowController();
  final CustomInfoWindowController _destinationcustomInfoWindowController =
      CustomInfoWindowController();
  bool _isShow = true;
  List<Map> latLongArr = [
    {'lat': 28.628151, 'long': 77.367783},
    {'lat': 28.597441, 'long': 77.390739},
  ];

  String? titlehelp = Prefs.getString("helptitle");

  bool loading = true;

  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 15,
              target: LatLng(
                  Prefs.getDouble("Latitude")!, Prefs.getDouble("Longitude")!),
              // target: LatLng(
              //   newLoc.latitude!,
              //   newLoc.longitude!,
              // ),
            ),
          ),
        );
      },
    );
  }

  LatLng? startLocation;
  LatLng? endLocation;

  // void _getRouteMapData() async {
  //   startLocation = LatLng(
  //     Prefs.getDouble("Latitude")!.toDouble(),
  //     Prefs.getDouble("Longitude")!.toDouble(),
  //   );
  //   print("startLocation:$startLocation");
  //
  //   endLocation = LatLng(
  //     widget.placeslist[0].geometry!.locationplace!.lat!.toDouble(),
  //     widget.placeslist[0].geometry!.locationplace!.lng!.toDouble(),
  //   );
  //   print("endLocation:$endLocation");
  //
  //
  //   Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  // }
  Position? currentPosition;
  var geoLocator = Geolocator();

  // getCurrentLocation() {
  //   geoLocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       currentPosition = position;
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
  @override
  void initState() {
    // _createMarker();
    getCurrentLocation();
    // _getRouteMapData();
    //
    // BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(size: Size(12, 12)), 'assets/images/user_location.png')
    //     .then((onValue) {
    //   sourceIcon = onValue;
    // });

    super.initState();
  }

  void _getPolyline() async {
    /// add origin marker origin marker
    markers.add(
      Marker(
        markerId: const MarkerId("source"),
        icon: sourceIcon,
        // position: startLocation,
        position: LatLng(
          Prefs.getDouble("Latitude")!.toDouble(),
          Prefs.getDouble("Longitude")!.toDouble(),
        ),
        onTap: () {
          print("source tapped");
          _sourcecustomInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/person.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            Prefs.getString("username").toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: FontName.poppinsMedium),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Text(
                            "Need help",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color(0xfffd3f3f),
                                fontFamily: FontName.poppinsRegular),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Triangle.isosceles(
                  edge: Edge.BOTTOM,
                  child: Container(
                    color: Colors.white,
                    width: 20.0,
                    height: 10.0,
                  ),
                ),
              ],
            ),
            LatLng(
              Prefs.getDouble("Latitude")!.toDouble(),
              Prefs.getDouble("Longitude")!.toDouble(),
            ),
          );
        },
      ),
    );

    for (var i = 0; i < widget.placeslist.length; i++) {
      var placesData = widget.placeslist[i];

      print("placesData:$placesData");
      double? placelat = placesData.geometry!.locationplace!.lat!.toDouble();
      Prefs.setDouble("placelat", placelat);
      double? placelong = placesData.geometry!.locationplace!.lng!.toDouble();
      Prefs.setDouble("placelong", placelong);

      markers.add(Marker(
        markerId: MarkerId(widget.placeslist[i].placeId.toString()),
        icon: destinationIcon,
        //  position: endLocation,
        position: LatLng(
          widget.placeslist[i].geometry!.locationplace!.lat!.toDouble(),
          widget.placeslist[i].geometry!.locationplace!.lng!.toDouble(),
        ),
        onTap: () {
          print("destination tapped");
          _destinationcustomInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            widget.placeslist[i].name.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: FontName.poppinsRegular),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),

                          //     : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                Triangle.isosceles(
                  edge: Edge.BOTTOM,
                  child: Container(
                    color: Colors.white,
                    width: 20.0,
                    height: 10.0,
                  ),
                ),
              ],
            ),
            LatLng(
              widget.placeslist[i].geometry!.locationplace!.lat!.toDouble(),
              widget.placeslist[i].geometry!.locationplace!.lng!.toDouble(),
            ),
          );
        },
      ));
    }

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCcLgRIDZsVGKCMB-YHDiEMvhB-DDW6MR4",
      PointLatLng(
        Prefs.getDouble("Latitude")!.toDouble(),
        Prefs.getDouble("Longitude")!.toDouble(),
      ),
      PointLatLng(Prefs.getDouble("placelat")!.toDouble(),
          Prefs.getDouble("placelong")!.toDouble()),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: Colors.deepPurple,
      width: 4,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  void dispose() {
    _sourcecustomInfoWindowController.dispose();
    _destinationcustomInfoWindowController.dispose();
    super.dispose();
  }

  void onCameraMove(CameraPosition position) {
    _sourcecustomInfoWindowController.onCameraMove!();
    _destinationcustomInfoWindowController.onCameraMove!();
  }

  BitmapDescriptor sourceIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor destinationIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 75,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: const Color(0xfff9fdfe),
        elevation: 0,
        title: Text(
          widget.title.toString().capitalize(),
          style: TextStyle(
            fontFamily: FontName.poppinsSemiBold,
            fontSize: 17,
            color: Color(0xff243444),
          ),
        ),
        leading: Builder(
          builder: (context) => Container(
            margin: const EdgeInsets.only(left: 10),
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: Image.asset(
                "assets/images/back.png",
                color: const Color(0xff000000),
                height: 21,
                width: 24,
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                ApiData.gridclickcount = 0;
                Navigator.pop(context);
                //  Navigator.of(context, rootNavigator: true).pop(context);
              },
            ),
          ),
        ),
      ),
      body: Stack(alignment: AlignmentDirectional.topCenter, children: [
        Column(
          children: [
            Container(
              height: Platform.isAndroid ? 680 : 600,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
              ),
              child: GoogleMap(
                myLocationEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                //   minMaxZoomPreference: const MinMaxZoomPreference(10, 15),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    Prefs.getDouble("Latitude")!.toDouble(),
                    Prefs.getDouble("Longitude")!.toDouble(),
                  ),

                  zoom: 15.0, //initial zoom level
                ),
                polylines: Set<Polyline>.of(polylines.values),
                markers: Set<Marker>.of(markers),
                // markers: {
                //   Marker(
                //     markerId: const MarkerId("source"),
                //     icon: destinationIcon,
                //     // position: startLocation,
                //     position: LatLng(
                //       Prefs.getDouble("Latitude")!.toDouble(),
                //       Prefs.getDouble("Longitude")!.toDouble(),
                //     ),
                //     onTap: () {
                //       print("source tapped");
                //       _sourcecustomInfoWindowController.addInfoWindow!(
                //           Column(
                //             children: [
                //               Expanded(
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(7.0),
                //                     color: Colors.white,
                //                     boxShadow: const [
                //                       BoxShadow(
                //                         color: Colors.black26,
                //                         blurRadius: 8.0,
                //                         offset: Offset(0.0, 5.0),
                //                       ),
                //                     ],
                //                   ),
                //                   width: double.infinity,
                //                   height: double.infinity,
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(5.0),
                //                     child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.center,
                //                       children: [
                //                         ClipOval(
                //                           child: Image.asset(
                //                             'assets/images/person.png',
                //                             height: 30,
                //                             width: 30,
                //                           ),
                //                         ),
                //                         const SizedBox(
                //                           width: 5.0,
                //                         ),
                //                         Text(
                //                           textAlign: TextAlign.center,
                //                           Prefs.getString("username")
                //                               .toString(),
                //                           style: const TextStyle(
                //                               fontSize: 12,
                //                               color: Colors.black,
                //                               fontFamily:
                //                                   FontName.poppinsMedium),
                //                         ),
                //                         const SizedBox(
                //                           width: 5.0,
                //                         ),
                //                         const Text(
                //                           "Need help",
                //                           style: TextStyle(
                //                               fontSize: 12,
                //                               fontWeight: FontWeight.normal,
                //                               color: Color(0xfffd3f3f),
                //                               fontFamily:
                //                                   FontName.poppinsRegular),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Triangle.isosceles(
                //                 edge: Edge.BOTTOM,
                //                 child: Container(
                //                   color: Colors.white,
                //                   width: 20.0,
                //                   height: 10.0,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           LatLng(
                //             Prefs.getDouble("Latitude")!.toDouble(),
                //             Prefs.getDouble("Longitude")!.toDouble(),
                //           ));
                //     },
                //   ),
                //   Marker(
                //     markerId: MarkerId("destination"),
                //     icon: sourceIcon,
                //     //  position: endLocation,
                //     position: LatLng(
                //       widget.placeslist[0].geometry!.locationplace!.lat!.toDouble(),
                //       widget.placeslist[0].geometry!.locationplace!.lng!.toDouble(),
                //     ),
                //     onTap: () {
                //       print("destination tapped");
                //       _destinationcustomInfoWindowController.addInfoWindow!(
                //           Column(
                //             children: [
                //               Expanded(
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(7.0),
                //                     color: Colors.white,
                //                     boxShadow: const [
                //                       BoxShadow(
                //                         color: Colors.black26,
                //                         blurRadius: 8.0,
                //                         offset: Offset(0.0, 5.0),
                //                       ),
                //                     ],
                //                   ),
                //                   width: double.infinity,
                //                   height: double.infinity,
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(5.0),
                //                     child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.center,
                //                       children: [
                //                         ClipOval(
                //                           child: Image.asset(
                //                             'assets/images/person.png',
                //                             height: 30,
                //                             width: 30,
                //                           ),
                //                         ),
                //                         const SizedBox(
                //                           width: 5.0,
                //                         ),
                //                         Text(
                //                           textAlign: TextAlign.center,
                //                           widget.placeslist[0].name.toString(),
                //                           style: const TextStyle(
                //                               fontSize: 12,
                //                               color: Colors.black,
                //                               fontFamily:
                //                                   FontName.poppinsRegular),
                //                         ),
                //                         const SizedBox(
                //                           width: 5.0,
                //                         ),
                //
                //                         //     : const SizedBox(),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Triangle.isosceles(
                //                 edge: Edge.BOTTOM,
                //                 child: Container(
                //                   color: Colors.white,
                //                   width: 20.0,
                //                   height: 10.0,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         LatLng(
                //           widget.placeslist[0].geometry!.locationplace!.lat!.toDouble(),
                //           widget.placeslist[0].geometry!.locationplace!.lng!.toDouble(),
                //         ),);
                //     },
                //   )
                // },

                mapType: MapType.normal,

                onCameraMove: onCameraMove,

                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  _sourcecustomInfoWindowController.googleMapController =
                      controller;
                  _destinationcustomInfoWindowController.googleMapController =
                      controller;
                  _getPolyline();
                },
                onTap: (position) {
                  _sourcecustomInfoWindowController.hideInfoWindow!();
                  _destinationcustomInfoWindowController.hideInfoWindow!();
                },
              ),
            ),
          ],
        ),
        CustomInfoWindow(
          controller: _sourcecustomInfoWindowController,
          height: 150,
          width: 150,
          offset: 50,
        ),
        CustomInfoWindow(
          controller: _destinationcustomInfoWindowController,
          height: 160,
          width: 150,
          offset: 50,
        ),
      ]),
    );
  }

  Widget showloading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
