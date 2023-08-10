import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:savealifedemoapp/bloc/User_bloc/user_bloc.dart';
import 'package:savealifedemoapp/bloc/User_bloc/user_event.dart';
import 'package:savealifedemoapp/ui/Userlocation/mapRequest.dart';

import '../../Model/GetAllUsersResponse.dart';
import '../../Model/Help/SendHelpRequestModel.dart';

import '../../Repository/SaveALifeRepository.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';

import '../GetHelpFrom/GetHelpMenuPage.dart';
import 'UsermapConstant.dart';

import 'package:intl/intl.dart';

class UsermapContent extends StatefulWidget {
  String accesstoken;

  // UserBloc userBloc;
  List<User> userslist;
  UserBloc userBloc;

  UsermapContent(
      {super.key,
        required this.accesstoken,
        required this.userslist,
        required this.userBloc
        // required this.userBloc,
      });

  @override
  _UsermapContentState createState() => _UsermapContentState();
}

class _UsermapContentState extends State<UsermapContent> {
  late GoogleMapController mapController; //contrller for Google map
  Set<Marker> markers = {}; //markers for google map
  // static const LatLng showLocation = LatLng(14.502680, 121.048912);

  var sendHelpRequestModel = SendHelpRequestModel();

  double sourcelat = 28.628151;
  double sourcelong = 77.367783;
  var buttonText = 'Send help Request';
  //LatLng startLocation = const LatLng(28.628151, 77.367783);
  LatLng? startLocation;

  LatLng endLocation = const LatLng(28.597441, 77.390739);
  LatLng carLocation = const LatLng(28.621309, 77.365471);
  double distance = 0.0;
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  bool onPressedValue=true;
  List<Map> latLongArr = [
    {'lat': 28.62491, 'long': 77.36984},
    {'lat': 28.62596, 'long': 77.36366},
    {'lat': 28.61195, 'long': 77.35937},
    {'lat': 28.62355, 'long': 77.38357},
    {'lat': 28.61541, 'long': 77.38872},
    {'lat': 28.60622, 'long': 77.35834},
    {'lat': 28.60890, 'long': 77.37181},
    {'lat': 28.61681, 'long': 77.38881},
    {'lat': 28.61127, 'long': 77.38503},
    {'lat': 28.60449, 'long': 77.38572},
    {'lat': 28.60765, 'long': 77.36932},
  ];

  bool loading = true;
  late Future _getCurrentLocationFuture;
  final GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  final Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  String? _address, _dateTime;
  Position? position;
  Widget? _child;
  BitmapDescriptor? myMarker;
  Location location = Location();

  late User users;

  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  // static LatLng latLng = const LatLng(28.626630, 77.365470);
  late LocationData currentLocation;
  bool isMount = true;

  @override
  void initState() {
    // _getCurrentLocationFuture =   getLoc();
    //getCurrentLocation();
    _createMarker();
    print('usermapcontent loaded');
    print('widget.userslist in usermapcontent:${widget.userslist}');
    //sendRequest();

    Prefs.setInt("isfireopen", 1);
    super.initState();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    mapController = _cntlr;
    _customInfoWindowController.googleMapController = _cntlr;
    location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude!.toDouble(), l.longitude!.toDouble()),
              zoom: 15),
        ),
      );
    });
  }

  void getCurrentLocation() async {
    final Uint8List markerIcon =
    await getBytesFromAsset('assets/images/user_location.png', 120);
    BitmapDescriptor markerbitmap = BitmapDescriptor.fromBytes(markerIcon);
    Position res = await Geolocator().getCurrentPosition();
    print("res:$res");
    setState(() {
      position = res;
      // _child = mapWidget();
      // startLocation = LatLng(position!.latitude, position!.longitude);
      // getmapmarkers(position!.latitude, position!.longitude);
      //  _lat=position!.latitude;
      //  _long=position!.longitude;
    });
    await getAddress(position!.latitude, position!.longitude);
  }

  List<Placemark> placemark = [];

  getAddress(double latitude, double longitude) async {
    placemark =
    await Geolocator().placemarkFromCoordinates(latitude, longitude);
    _address = "${placemark[0].name},${placemark[0].subLocality},${placemark[0].locality},${placemark[0].postalCode}";

    // setState(() {
    //   _child = mapWidget();
    // });
  }

  Set<Marker> _createMarker() {
    for (var i = 0; i < widget.userslist.length; i++) {
      var userData = widget.userslist[i];
      double? lat = userData.lat;
      Prefs.setDouble("lat", lat);
      double? long = userData.long;
      Prefs.setDouble("long", long);
      markers.add(
        Marker(
          markerId: MarkerId(widget.userslist[i].lat.toString()),
          position: LatLng(
            userData.lat,
            userData.long,
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
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
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/person.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              userData.username ?? "",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontName.poppinsRegular,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),

                            userData.address != null
                                ? Text(
                              userData.address ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: FontName.poppinsRegular,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black45),
                            )
                                : const SizedBox(),
                            const SizedBox(
                              height: 5.0,
                            ),

                            Text(
                              userData.mobile ?? "",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: FontName.poppinsRegular,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xff254fd5)),
                            ),

                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //       backgroundColor: const Color(0xff254fd5),
                            //       elevation: 3,
                            //       textStyle: const TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 10,
                            //           fontStyle: FontStyle.normal),
                            //       shape: RoundedRectangleBorder(
                            //           //to set border radius to button
                            //           borderRadius: BorderRadius.circular(5)),
                            //       padding: const EdgeInsets.all(5)),
                            //   onPressed: () {
                            //     // Send help request Button Acction
                            //     var sendHelpRequestModelData =
                            //         sendHelpRequestParams(i);
                            //     widget.userBloc.add(SendHelpRequestEvent(
                            //         sendHelpRequestModel:
                            //             sendHelpRequestModelData));
                            //
                            //     Prefs.setInt("sender", 1);
                            //     final snackBar = SnackBar(
                            //       backgroundColor: Colors.green,
                            //       content: Row(
                            //         children: const [
                            //           Icon(
                            //             color: Colors.white,
                            //             Icons.warning,
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Text(
                            //             'Waiting for Confirmation...',
                            //             style: TextStyle(
                            //               fontSize: 14,
                            //               fontFamily: FontName.poppinsMedium,
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //       duration: const Duration(seconds: 10),
                            //       behavior: SnackBarBehavior.floating,
                            //     );
                            //     ScaffoldMessenger.of(context)
                            //         .showSnackBar(snackBar);
                            //   },
                            //   child: const Text(
                            //     'Send Help Request',
                            //     style: TextStyle(
                            //       fontSize: 12,
                            //       fontFamily: FontName.poppinsMedium,
                            //     ),
                            //   ),
                            // ),
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
              // LatLng(
              //   position!.latitude.toDouble(),
              //   position!.longitude.toDouble(),
              // ),
              LatLng(
                userData.lat!,
                userData.long!,
              ),
            );
          },
        ),
      );
    }

    return markers;
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void _selectedTab(int index) {
    if (index == 1) {
      // navigateToProfile();
    }
  }

  void onCameraMove(CameraPosition position) {
    // latLng = position.target;
    // startLocation = position.target;
    _customInfoWindowController.onCameraMove!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff9fdfe),
        body: Stack(alignment: AlignmentDirectional.topCenter, children: [
          GoogleMap(
            zoomGesturesEnabled: true,

            // initialCameraPosition: CameraPosition(
            //   //innital position in map
            //   target: startLocation, //initial position
            //   zoom: 14.0, //initial zoom level
            // ),
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  Prefs.getDouble("lat")!,
                  Prefs.getDouble("long")!,
                ),
                zoom: 7),

            markers: _createMarker(),

            mapType: MapType.normal,

            onCameraMove: onCameraMove,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
            // onMapCreated: _onMapCreated,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 175,
            width: 150,
            offset: 50,
          ),
          Positioned(
            top: 10,
            left: 50,
            child: Card(
              child: Container(
                  height: 70,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/user_search.png",
                          height: 50,
                          width: 50,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Locating peoples in the area',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal)),
                          Text(
                              widget.userslist.length > 1
                                  ? '${widget.userslist.length} peoples in your area'
                                  : '${widget.userslist.length} person in your area',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColor.red)),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
          Positioned(
              bottom: 15,
              left: 90,
              child:
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff254fd5),
                    elevation: 3,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                    shape: RoundedRectangleBorder(
                      //to set border radius to button
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: onPressedValue==true?(){
                    setState((){
                      onPressedValue=false;
                      var sendHelpRequestModelData = sendHelpRequestParams(0);
                      widget.userBloc.add(SendHelpRequestEvent(
                          sendHelpRequestModel: sendHelpRequestModelData));

                      Prefs.setInt("sender", 1);
                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Row(
                          children: const [
                            Icon(
                              color: Colors.white,
                              Icons.warning,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Waiting for Confirmation...',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontName.poppinsMedium,
                              ),
                            )
                          ],
                        ),
                        duration: const Duration(seconds: 10),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    });
                    Timer(Duration(seconds: 11),(){
                      setState((){
                        onPressedValue=true;
                      });
                    });

                  }:null,
                  child:  Text(
                    "Send Help Request",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontName.poppinsMedium,
                    ),
                  ))

          )
        ]));
  }

  //
  SendHelpRequestModel sendHelpRequestParams(int i) {
    //  sendHelpRequestModel.fromDevId = '26DC8B41-FC02-4391-9D21-01757DBAB7CA';
    sendHelpRequestModel.fromDevId = Prefs.getString("deviceid");
    sendHelpRequestModel.fromDevToken = Prefs.getString("fcmToken");
    sendHelpRequestModel.fromDevType = Platform.isIOS ? 'iOS' : 'Android';
    sendHelpRequestModel.fromUserId = Prefs.getInt("userid").toString();
    // sendHelpRequestModel.fromLat = position!.latitude!;
    // sendHelpRequestModel.fromLong = position!.longitude!;
    sendHelpRequestModel.fromLat = Prefs.getDouble("Latitude");
    sendHelpRequestModel.fromLong = Prefs.getDouble("Longitude");
    //  sendHelpRequestModel.fromAddress = _address;
    sendHelpRequestModel.fromAddress = Prefs.getString("ProfileAddress");
    sendHelpRequestModel.message =
    'Hey, I need urgent help in ${Prefs.getString("ProfileAddress")}.';
    sendHelpRequestModel.toDevId = widget.userslist[i].deviceid;
    sendHelpRequestModel.toDevToken = widget.userslist[i].devtoken;
    sendHelpRequestModel.toDevType = Platform.isIOS ? 'iOS' : 'Android';
    sendHelpRequestModel.toUserId = widget.userslist[i].id.toString();
    sendHelpRequestModel.toLat = Prefs.getDouble("Latitude");
    sendHelpRequestModel.toLong = Prefs.getDouble("Longitude");
    sendHelpRequestModel.toAddress = widget.userslist[i].address;
    sendHelpRequestModel.helptype = 1;
    sendHelpRequestModel.sendername = Prefs.getString("username");
    sendHelpRequestModel.senderemail = Prefs.getString("email");
    sendHelpRequestModel.sendermobile = Prefs.getString("mobile");

    return sendHelpRequestModel;
  }
// Widget mapWidget() {
//   return Stack(alignment: AlignmentDirectional.topCenter, children: [
//     GoogleMap(
//       zoomGesturesEnabled: true,
//
//       // initialCameraPosition: CameraPosition(
//       //   //innital position in map
//       //   target: startLocation, //initial position
//       //   zoom: 14.0, //initial zoom level
//       // ),
//       initialCameraPosition: CameraPosition(
//           target: LatLng(
//             Prefs.getDouble("lat")!,
//             Prefs.getDouble("long")!,
//           ),
//           zoom: 15),
//
//       markers: _createMarker(),
//
//       mapType: MapType.normal,
//
//       onCameraMove: onCameraMove,
//       onMapCreated: (GoogleMapController controller) {
//         _controller.complete(controller);
//         _customInfoWindowController.googleMapController = controller;
//       },
//       // onMapCreated: _onMapCreated,
//       onTap: (position) {
//         _customInfoWindowController.hideInfoWindow!();
//       },
//     ),
//     CustomInfoWindow(
//       controller: _customInfoWindowController,
//       height: 175,
//       width: 150,
//       offset: 50,
//     ),
//     Positioned(
//       top: 10,
//       left: 50,
//       child: Card(
//         child: Container(
//             height: 70,
//             padding: const EdgeInsets.all(15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   child: Image.asset(
//                     "assets/images/user_search.png",
//                     height: 50,
//                     width: 50,
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Locating peoples in the area',
//                         style: TextStyle(

//                             fontSize: 15, fontWeight: FontWeight.normal)),
//                     Text(
//                         widget.userslist.length > 1
//                             ? '${widget.userslist.length} peoples in your area'
//                             : '${widget.userslist.length} person in your area',
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: ThemeColor.red)),
//                   ],
//                 ),
//               ],
//             )),
//       ),
//     ),
//   ]);
// }
}
