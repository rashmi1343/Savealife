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

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/bloc/SendHelpBloc/send_help_bloc.dart';
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
import 'UsermapConstant.dart';

class MapViewRoute extends StatefulWidget {
  String accesstoken;

  //List<User> userslist;

  MapViewRoute({
    super.key,
    required this.accesstoken,
    // required this.userslist,
  });

  @override
  _MapViewRouteState createState() => _MapViewRouteState();
}

class _MapViewRouteState extends State<MapViewRoute> {
  late GoogleMapController mapController; //contrller for Google map
  Set<Marker> markers = {}; //markers for google map
  // static const LatLng showLocation = LatLng(14.502680, 121.048912);

  var sendHelpRequestModel = SendHelpRequestModel();

  double sourcelat = 28.628151;
  double sourcelong = 77.367783;

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
              zoom: 10,
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

  GetRouteForMapResponse getRouteForMapResponse = GetRouteForMapResponse(
      status: 0,
      userhelprequest: UserhelprequestRoute(
          id: 1,
          fromDevId: '',
          fromDevToken: '',
          toDevId: '',
          toDevToken: '',
          fromUserId: 1,
          toUserId: 1,
          helptype: 1,
          fromDevType: '',
          toDevType: '',
          fromLat: 23.90,
          fromLong: 54.67,
          toLat: 34.24,
          toLong: 32.12,
          fromAddress: '',
          toAddress: '',
          ishelpaccepted: 0,
          sendername: '',
          senderemail: '',
          sendermobile: '',
          createdAt: '',
          updatedAt: ''),
      userhelpaccept: UserhelpacceptRoute(
          id: 1,
          acceptedDevId: '',
          acceptedDevToken: '',
          acceptedUserId: 1,
          helptype: 1,
          lat: 12.45,
          long: 13.67,
          address: '',
          ishelpaccepted: 0,
          helprequestid: 1,
          recevierid: '1',
          receivername: '',
          receiveremail: '',
          receivermobile: '',
          createdAt: '',
          updatedAt: ''));

  void _getRouteMapData() async {
    getRouteForMapResponse = (await SaveaLifeRepository()
        .getrouteformapApi(Prefs.getInt("helprequestid")!.toInt()));
    startLocation = LatLng(
      getRouteForMapResponse.userhelprequest!.fromLat!.toDouble(),
      getRouteForMapResponse.userhelprequest!.fromLong!.toDouble(),
    );
    print("startLocation:$startLocation");

    endLocation = LatLng(
      getRouteForMapResponse.userhelpaccept!.lat!.toDouble(),
      getRouteForMapResponse.userhelpaccept!.long!.toDouble(),
    );
    print("endLocation:$endLocation");
    getPolyPoints(startLocation, endLocation);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void getPolyPoints(LatLng? startLocation, LatLng? endLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCcLgRIDZsVGKCMB-YHDiEMvhB-DDW6MR4", // Your Google Map Key
      PointLatLng(startLocation!.latitude, startLocation.longitude),
      PointLatLng(endLocation!.latitude, endLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
    }
  }

  // void getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyCcLgRIDZsVGKCMB-YHDiEMvhB-DDW6MR4", // Your Google Map Key
  //     PointLatLng(startLocation!.latitude, startLocation!.longitude),
  //     PointLatLng(endLocation!.latitude, endLocation!.longitude),
  //   );
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach(
  //       (PointLatLng point) => polylineCoordinates.add(
  //         LatLng(point.latitude, point.longitude),
  //       ),
  //     );
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    _getRouteMapData();

    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To gethelpdashboard Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
    if (["gethelpdashboardRoute"].contains(info.currentRoute(context)))
      return true;

    return false;
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    mapController = _cntlr;
    _sourcecustomInfoWindowController.googleMapController = _cntlr;
    _destinationcustomInfoWindowController.googleMapController = _cntlr;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                getRouteForMapResponse.userhelpaccept!.lat!.toDouble(),
                getRouteForMapResponse.userhelpaccept!.long!.toDouble()),
            zoom: 15),
      ),
    );
  }

  @override
  void dispose() {
    _sourcecustomInfoWindowController.dispose();
    _destinationcustomInfoWindowController.dispose();
    super.dispose();
  }

  void _selectedTab(int index) {
    if (index == 1) {
      // navigateToProfile();
    }
  }

  void onCameraMove(CameraPosition position) {
    _sourcecustomInfoWindowController.onCameraMove!();
    _destinationcustomInfoWindowController.onCameraMove!();
  }

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Future<void> setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/user_location.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/pin.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

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
        title: const Text(
          "Help Route",
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GetHelpMenuPage(
                          savealiferep: SaveaLifeRepository(),
                          accesstoken:
                              Prefs.getString("accesstoken").toString(),
                          userid: Prefs.getInt("userid")!,
                        )));
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
              height: Platform.isAndroid ? 600 : 500,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
              ),
              child:
                  // currentLocation == null
                  //     ? const Center(child: CircularProgressIndicator( color: const Color(0xFF7B61FF),))
                  //     :
                  GoogleMap(
                //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true,
                //enable Zoom in, out on map
                initialCameraPosition: CameraPosition(
                  //innital position in map
                  target: LatLng(Prefs.getDouble("Latitude")!,
                      Prefs.getDouble("Longitude")!),
                  //initial position
                  zoom: 12.0, //initial zoom level
                ),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    // color: const Color(0xFF7B61FF),
                    color: const Color(0xFF7B61FF),
                    width: 4,
                  ),
                },
                markers: {
                  // Marker(
                  //   markerId: const MarkerId("currentLocation"),
                  //   icon: currentLocationIcon,
                  //   position: LatLng(
                  //       currentLocation!.latitude!, currentLocation!.longitude!),
                  // ),
                  Marker(
                    markerId: const MarkerId("source"),
                    icon: destinationIcon,
                    // position: startLocation,
                    position: LatLng(
                      getRouteForMapResponse.userhelprequest!.fromLat!
                          .toDouble(),
                      getRouteForMapResponse.userhelprequest!.fromLong!
                          .toDouble(),
                      // latLongArr[0]['lat'],
                      // latLongArr[0]['long'],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        getRouteForMapResponse
                                            .userhelprequest!.sendername
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: FontName.poppinsMedium),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),

                                      Text(
                                        getRouteForMapResponse
                                            .userhelprequest!.senderemail
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontFamily:
                                                FontName.poppinsRegular),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        getRouteForMapResponse
                                            .userhelprequest!.sendermobile
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontFamily:
                                                FontName.poppinsRegular),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        "Need help from :Fire",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xfffd3f3f),
                                            fontFamily:
                                                FontName.poppinsRegular),
                                      ),
                                      // const SizedBox(
                                      //   width: 5.0,
                                      // ),
                                      // widget.userslist[0].address != null
                                      //     ? Text(
                                      //   widget.userslist[0].address ?? "",
                                      //   style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.normal,
                                      //       color: Colors.red),
                                      // )
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
                          getRouteForMapResponse.userhelprequest!.fromLat!
                              .toDouble(),
                          getRouteForMapResponse.userhelprequest!.fromLong!
                              .toDouble(),
                          // latLongArr[0]['lat'],
                          // latLongArr[0]['long'],
                        ),
                      );
                    },
                  ),
                  Marker(
                    markerId: const MarkerId("destination"),
                    icon: sourceIcon,
                    //  position: endLocation,
                    position: LatLng(
                        getRouteForMapResponse.userhelpaccept!.lat!.toDouble(),
                        getRouteForMapResponse.userhelpaccept!.long!
                            .toDouble()),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        getRouteForMapResponse
                                            .userhelpaccept!.receivername
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: FontName.poppinsMedium),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),

                                      Text(
                                        getRouteForMapResponse
                                            .userhelpaccept!.receiveremail
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontFamily:
                                                FontName.poppinsRegular),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),

                                      Text(
                                        getRouteForMapResponse
                                            .userhelpaccept!.receivermobile
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontFamily:
                                                FontName.poppinsRegular),
                                      ),
                                      const Text(
                                        "is on the way to help",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xfffd3f3f),
                                            fontFamily:
                                                FontName.poppinsRegular),
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
                            getRouteForMapResponse.userhelpaccept!.lat!
                                .toDouble(),
                            getRouteForMapResponse.userhelpaccept!.long!
                                .toDouble()),
                      );
                    },
                  ),
                },
                //markers to show on map
                mapType: MapType.normal,
                //map type
                onCameraMove: onCameraMove,
                // onMapCreated:_onMapCreated,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  _sourcecustomInfoWindowController.googleMapController =
                      controller;
                  _destinationcustomInfoWindowController.googleMapController =
                      controller;
                },
                onTap: (position) {
                  _sourcecustomInfoWindowController.hideInfoWindow!();
                  _destinationcustomInfoWindowController.hideInfoWindow!();
                },
              ),
            ),
            Visibility(
              visible: _isShow,
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isShow = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emoji.png',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Help is on the way',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontName.poppinsMedium,
                          )),
                    ],
                  ),
                ),
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
          height: 150,
          width: 150,
          offset: 50,
        ),
      ]),
      // bottomNavigationBar: FABBottomAppBar(
      //   centerItemText: '',
      //   color: Colors.grey,
      //   selectedColor: const Color.fromARGB(255, 12, 87, 216),
      //   notchedShape: const CircularNotchedRectangle(),
      //   onTabSelected: _selectedTab,
      //   items: [
      //     FABBottomAppBarItem(iconData:"assets/images/log_out.png", text: ''),
      //     FABBottomAppBarItem(iconData: "assets/images/user.png", text: ''),
      //   ],
      //   backgroundColor: Colors.white,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: _buildFab(context),
    );
  }

  Widget showloading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFab(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy * 35.0),
          child: const SizedBox(),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 12, 87, 216),
        elevation: 10.0,
        child: Image.asset(
          "assets/images/home.png",
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
