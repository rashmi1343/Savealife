import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/bloc/User_bloc/user_bloc.dart';
import 'package:savealifedemoapp/ui/AboutUsPage.dart';

import 'package:savealifedemoapp/ui/HomeDashboard/Dashboardcontent.dart';
import 'package:savealifedemoapp/ui/Members/UserPage.dart';
import 'package:savealifedemoapp/ui/Profile/ProfilePage.dart';
import 'package:savealifedemoapp/ui/SettingPage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/GetAllMenuResponse.dart';
import '../../bloc/Gethelpmenu_bloc/gethelpmenu_bloc.dart';
import '../../bloc/Homedashboard_bloc/homedashboard_bloc.dart';
import '../../bloc/Profile_bloc/profile_bloc.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../Calling/CallUserPage.dart';
import '../Chat/ChatPage.dart';

import '../NavigationBar/fab_bottom_app_bar.dart';
import '../NavigationBar/layout.dart';
import '../Profile/Profilebasepage.dart';
import '../Signin/SigninPage.dart';

class homedashboard extends StatefulWidget {
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  int id;

  @override
  homedashboard(
      {required this.savealiferep, required this.accesstoken, required this.id})
      : assert(savealiferep != null),
        super();

  @override
  State<homedashboard> createState() => _homedashboardState();
}

class _homedashboardState extends State<homedashboard>
    with TickerProviderStateMixin {
  String _lastSelected = 'TAB: 0';
  late homedashboardbloc _homedashboardbloc;
  late String accesstoken;

  SaveaLifeRepository get _Repository => widget.savealiferep;
  late List<Menu> homemenucontent = [];

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);

    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // cleardata();
    return false;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(
              'Confirm Exit',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111111),
                  fontFamily: FontName.poppinsRegular),
            ),
            content: const Text(
              'Are you sure you want to exit?',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff111111),
                  fontFamily: FontName.poppinsRegular),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontFamily: FontName.poppinsRegular),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontFamily: FontName.poppinsRegular),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  // void _selectedTab(int index) {
  //   setState(() {
  //     _lastSelected = 'TAB: $index';
  //     print("_lastSelected:$_lastSelected");
  //
  //     if(index==1){
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => ProfilePage(accesstoken:widget.accesstoken,id:widget.id, savealiferep: widget.savealiferep)));
  //     }
  //
  //   });
  // }
  void logoutcontent() {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return Container(
            height: 100,
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: Platform.isAndroid ? 300.0 : 100,
                ),
                title: Text(
                  "Logout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontName.poppinsSemiBold,
                    fontSize: 16,
                    color: Color(0xff243444),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      "Do you Really want to logout?",
                      style: TextStyle(
                        fontFamily: FontName.poppinsMedium,
                        fontSize: 13,
                        color: Color(0xff243444),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: FontName.poppinsRegular,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            //onPrimary: Colors.black,
                          ),
                        ),
                        ElevatedButton(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontFamily: FontName.poppinsRegular,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Prefs.remove("email");
                            Prefs.remove("accesstoken");

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return SigninPage(
                                saveliferepo: SaveaLifeRepository(),
                              );
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            //onPrimary: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  void _selectedTab(int index) {
    print(_lastSelected);
    if (index == 0) {
      logoutcontent();
    } else if (index == 1) {
      navigateToProfile();
    }
  }

  late int _totalNotifications;
  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    Prefs.remove("isfireopen");
    accesstoken = widget.accesstoken.toString();
    _homedashboardbloc = homedashboardbloc(
        saveaLifeRepository: _Repository, accesstoken: accesstoken);

    _homedashboardbloc.add(loadedhomedashboard());

    // BackButtonInterceptor.add(myInterceptor);
    //   _totalNotifications = 0;
  }

  @override
  Widget build(BuildContext context) {
    // adding blocbuilder for menu
    //  return Container(child:Center(child:Text("Home Dashboard")));
    return BlocBuilder<homedashboardbloc, homedashboardstate>(
        bloc: _homedashboardbloc,
        builder: (BuildContext context, homedashboardstate state) {
          if (state is loadinghomedashboardstate) {
            showloading();
          }
          if (state is loadedhomedashboardstate) {
            print("home dashboard loaded ");
            homemenucontent = state.menu;
            if(homemenucontent.isEmpty){
              _onWidgetDidBuild(() {
                Fluttertoast.showToast(
                    msg: "Token may have Expired,\n Please login again",
                    //message to show toast
                    toastLength: Toast.LENGTH_SHORT,
                    //duration for message to show
                    gravity: ToastGravity.BOTTOM,
                    //where you want to show, top, bottom

                    backgroundColor: Colors.red,
                    //background Color for message
                    textColor: Colors.white,
                    //message text color
                    fontSize: 16.0 //message font size
                );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SigninPage(saveliferepo: SaveaLifeRepository())),
              );
              });
            }
          }
          if (state is clickhomedashboarditemstate) {
            print("menu id clicked :${state.menuid}");

            _onWidgetDidBuild(() {
              if (state.menuid == 0) {
                 ApiData.gridclickcount=0;
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutUsPage()));
              }
              else if (state.menuid == 1) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPage(
                        savealiferep: _Repository,
                        accesstoken: widget.accesstoken,
                        id: widget.id)));
              } else if (state.menuid == 2) {
                ApiData.gridclickcount = 0;
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => LocationPage()));
                //   _makingPhoneCall();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CallUserPage(
                        savealiferep: _Repository,
                        accesstoken: widget.accesstoken,
                        id: widget.id)));


              } else if (state.menuid == 3) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPage()));

              } else if (state.menuid == 4) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserPage(
                        savealiferep: _Repository,
                        accesstoken: widget.accesstoken,
                        id: widget.id)));
              } else if (state.menuid == 5) {
                ApiData.gridclickcount = 0;
              }
            });
          }
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: const Color(0xfff9fdfe),
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 1,
                backgroundColor: const Color(0xfff9fdfe),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  systemNavigationBarIconBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
                // actions: [
                //   Stack(
                //     children: [
                //       Container(
                //           margin: const EdgeInsets.only(right: 20),
                //           height: 40,
                //           child: SvgPicture.asset(
                //             "assets/images/bell_solid.svg",
                //             color: Color(0xffc32c37),
                //             width: 40,
                //             height: 40,
                //           )
                //           // Icon(
                //           //   Icons.notifications,
                //           //   color:Color(0xffc32c37),
                //           //   size: 30,
                //           // ),
                //           ),
                //       NotificationBadge(totalNotifications: _totalNotifications),
                //     ],
                //   ),
                // ],
              ),

              body: Dashboardcontent(
                homemenucontent: homemenucontent,
                savealiferep: widget.savealiferep,
                accesstoken: widget.accesstoken,
                hmdashbrdbloc: _homedashboardbloc,
                userid: widget.id,
              ),
              bottomNavigationBar: FABBottomAppBar(
                centerItemText: '',
                color: Colors.grey,
                selectedColor: const Color.fromARGB(255, 12, 87, 216),
                notchedShape: const CircularNotchedRectangle(),
                onTabSelected: _selectedTab,
                items: [
                  FABBottomAppBarItem(
                      iconData: "assets/images/log_out.png", text: ''),
                  FABBottomAppBarItem(
                      iconData: "assets/images/user.png", text: ''),
                ],
                backgroundColor: Colors.white,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _buildFab(
                  context), // This trailing comma makes auto-formatting nicer for build methods.;
            ),
          );
        });
  }

  Widget _buildFab(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy * 35.0),
          child: const SizedBox(),
          // FabWithIcons(
          //   icons: icons,
          //   onIconTapped: _selectedFab,
          // ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 12, 87, 216),
        child: Image.asset(
          "assets/images/home.png",
          height: 30,
          width: 30,
        ),
        elevation: 10.0,
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  navigateToProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>

          // Profilebasepage(

          //     accesstoken: widget.accesstoken,

          //     Reposavealife: widget.savealiferep,

          //     userid: widget.userid)

          BlocProvider(
              create: (context) => ProfileBloc(
                  accesstoken: widget.accesstoken,
                  savealifeRepository: _Repository,
                  userid: widget.id),
              child: Profilebasepage(
                Reposavealife: _Repository,
                accesstoken: widget.accesstoken,
                userid: widget.id,
              )),
    ));
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:9776765434");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xffc32c37),
            border: Border.all(color: Colors.white, width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: Text(
              '$totalNotifications',
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }
}

Widget showloading() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
