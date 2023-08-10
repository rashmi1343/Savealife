import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savealifedemoapp/Model/GetHelpMenuResponse.dart';

import '../../bloc/Gethelpmenu_bloc/gethelpmenu_bloc.dart';
import '../../bloc/SendHelpBloc/send_help_bloc.dart';
import '../../bloc/User_bloc/user_bloc.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../HomeDashboard/homedashboard.dart';
import '../Medical/NearByPlaces.dart';
import '../Medical/MedicalCategories.dart';
import '../NavigationBar/fab_bottom_app_bar.dart';
import '../NavigationBar/layout.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/ui/HomeDashboard/Dashboardcontent.dart';

import '../../Model/GetAllMenuResponse.dart';
import '../../bloc/Homedashboard_bloc/homedashboard_bloc.dart';
import '../NavigationBar/fab_bottom_app_bar.dart';
import '../NavigationBar/layout.dart';
import '../Signin/SigninPage.dart';
import '../Userlocation/UsermapPage.dart';

import 'GetHelpContent.dart';

class GetHelpMenuPage extends StatefulWidget {
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  int userid;

  @override
  GetHelpMenuPage(
      {required this.savealiferep,
        required this.accesstoken,
        required this.userid})
      : assert(savealiferep != null),
        super();

  @override
  State<GetHelpMenuPage> createState() => _GetHelpMenuPageState();
}

class _GetHelpMenuPageState extends State<GetHelpMenuPage>
    with TickerProviderStateMixin {
  String _lastSelected = 'TAB: 0';
  late GethelpMenuBloc _gethelpfromBloc;
  late String accesstoken;

  SaveaLifeRepository get _Repository => widget.savealiferep;
  late List<Gethelp> gethelpmenucontent = [];

  @override
  void initState() {
    // TODO: implement initState
    accesstoken = widget.accesstoken.toString();
    _gethelpfromBloc = GethelpMenuBloc(
        saveaLifeRepository: _Repository, accesstoken: accesstoken);

    _gethelpfromBloc.add(loadedGethelpmenu());
    // BackButtonInterceptor.add(myInterceptor);
  }

//   bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
//     print("Back To Homedashboard Page");
//     //  Navigator.pop(context);
//     ApiData.gridclickcount = 0;
//     _gethelpfromBloc.add(NavigateToHomeEvent());
//     // SchedulerBinding.instance.addPostFrameCallback((_) {
//     //   Navigator.of(context).push(MaterialPageRoute(
//     //       builder: (context) => homedashboard(
//     //         savealiferep: _Repository,
//     //         accesstoken: accesstoken,
//     //         id: Prefs.getInt("userid")!,
//     //       )));
//     // });
//     // Navigator.push(context,
//     //   MaterialPageRoute(
//     //     builder: (context) => TaskDetailView(taskId: data.taskId),
//     //   ),
//     // ).then((_) => ...YourEvent);
//     //Navigator. of(context). pop();
//
// // Navigator.pop(context);
//    // Navigator.of(context).pushNamed( '/homedashboardRoute');
//     // if (["homedashboardRoute"].contains(info.currentRoute(context)))
//     //   return true;
//
//     return true;
//   }

  //
  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }
  void moveToLastScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // adding blocbuilder for menu
    //  return Container(child:Center(child:Text("Home Dashboard")));
    return BlocBuilder<GethelpMenuBloc, GethelpMenuState>(
        bloc: _gethelpfromBloc,
        builder: (BuildContext context, GethelpMenuState state) {
          if (state is LoadingGetHelpMenuState) {
            showloading();
          }
          if (state is LoadedGetHelpMenustate) {
            print("GetHelp From dashboard loaded ");

            gethelpmenucontent = state.gethelpmenu;

            if (gethelpmenucontent.isEmpty) {
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
          // if (state is NavigateToHomeState) {
          //
          //   print("Navigate to home dashboard ");
          //   SchedulerBinding.instance.addPostFrameCallback((_) {
          //    // Navigator.pop(context);
          //     Timer(Duration(seconds: 4), () {
          //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
          //         return homedashboard(
          //           savealiferep: _Repository,
          //           accesstoken: accesstoken,
          //           id: Prefs.getInt("userid")!,
          //         );
          //       }));
          //     });
          //
          //     // Navigator.of(context).push(MaterialPageRoute(
          //     //     builder: (context) => homedashboard(
          //     //       savealiferep: _Repository,
          //     //       accesstoken: accesstoken,
          //     //       id: Prefs.getInt("userid")!,
          //     //     )));
          //   });
          // }
          // if (state is ClickGetHelpMenuState) {
          //   _onWidgetDidBuild(() {
          //     print("gethelp menu loaded ${state.gethelpmenuId}");
          //     Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => Usermaplocation()));
          //   });
          //
          //   print("helpmenuid" + state.gethelpmenuId.toString());
          // }
          if (state is ClickGetHelpMenuState) {
            print("helpmenuid" + state.gethelpmenuId.toString());
            _onWidgetDidBuild(() {
              if (state.gethelpmenuId == 0) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SendHelpBloc>(
                          create: (context) => SendHelpBloc(
                            accesstoken: widget.accesstoken,
                            saveALiferepository: _Repository,
                          ),
                        ),
                        BlocProvider<UserBloc>(
                          create: (context) => UserBloc(
                            accesstoken: widget.accesstoken,
                            saveaLifeRepository: _Repository,
                            id: widget.userid,
                          ),
                        )
                      ],
                      child: UsermapPage(
                        accesstoken: widget.accesstoken,
                        userid: widget.userid,
                        savealiferep: widget.savealiferep,
                      )),
                ));
              } else if (state.gethelpmenuId == 1) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MedicalCategories()));
              } else if (state.gethelpmenuId == 2) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SendHelpBloc>(
                          create: (context) => SendHelpBloc(
                            accesstoken: widget.accesstoken,
                            saveALiferepository: _Repository,
                          ),
                        ),
                        BlocProvider<UserBloc>(
                          create: (context) => UserBloc(
                            accesstoken: widget.accesstoken,
                            saveaLifeRepository: _Repository,
                            id: widget.userid,
                          ),
                        )
                      ],
                      child: UsermapPage(
                        accesstoken: widget.accesstoken,
                        userid: widget.userid,
                        savealiferep: widget.savealiferep,
                      )),
                ));
              } else if (state.gethelpmenuId == 3) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SendHelpBloc>(
                          create: (context) => SendHelpBloc(
                            accesstoken: widget.accesstoken,
                            saveALiferepository: _Repository,
                          ),
                        ),
                        BlocProvider<UserBloc>(
                          create: (context) => UserBloc(
                            accesstoken: widget.accesstoken,
                            saveaLifeRepository: _Repository,
                            id: widget.userid,
                          ),
                        )
                      ],
                      child: UsermapPage(
                        accesstoken: widget.accesstoken,
                        userid: widget.userid,
                        savealiferep: widget.savealiferep,
                      )),
                ));
              } else if (state.gethelpmenuId == 4) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SendHelpBloc>(
                          create: (context) => SendHelpBloc(
                            accesstoken: widget.accesstoken,
                            saveALiferepository: _Repository,
                          ),
                        ),
                        BlocProvider<UserBloc>(
                          create: (context) => UserBloc(
                            accesstoken: widget.accesstoken,
                            saveaLifeRepository: _Repository,
                            id: widget.userid,
                          ),
                        )
                      ],
                      child: UsermapPage(
                        accesstoken: widget.accesstoken,
                        userid: widget.userid,
                        savealiferep: widget.savealiferep,
                      )),
                ));
              } else if (state.gethelpmenuId == 5) {
                ApiData.gridclickcount = 0;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SendHelpBloc>(
                          create: (context) => SendHelpBloc(
                            accesstoken: widget.accesstoken,
                            saveALiferepository: _Repository,
                          ),
                        ),
                        BlocProvider<UserBloc>(
                          create: (context) => UserBloc(
                            accesstoken: widget.accesstoken,
                            saveaLifeRepository: _Repository,
                            id: widget.userid,
                          ),
                        )
                      ],
                      child: UsermapPage(
                        accesstoken: widget.accesstoken,
                        userid: widget.userid,
                        savealiferep: widget.savealiferep,
                      )),
                ));
              }
            });
          }

          return GetHelpContent(
            gethelpmenucontent: gethelpmenucontent,
            gethelpfromBloc: _gethelpfromBloc,
            accesstoken: widget.accesstoken,
            userid: widget.userid,
            savealiferep: widget.savealiferep,
          );

          // return Scaffold(
          //   // backgroundColor: Color(0xfff9fdfe),
          //   // appBar: AppBar(
          //   //   toolbarHeight: 75,
          //   //   systemOverlayStyle: const SystemUiOverlayStyle(
          //   //     statusBarColor: Color(0xfff9fdfe),
          //   //     systemNavigationBarIconBrightness: Brightness.light,
          //   //     statusBarIconBrightness: Brightness.dark,
          //   //     statusBarBrightness: Brightness.light,
          //   //   ),
          //   //   backgroundColor: Color(0xfff9fdfe),
          //   //   elevation: 0,
          //   //   centerTitle: false,
          //   //   title: Transform(
          //   //     // you can forcefully translate values left side using Transform
          //   //     transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
          //   //     child: const Text(
          //   //       'Get Help From',
          //   //       softWrap: false,
          //   //       overflow: TextOverflow.ellipsis,
          //   //       style: TextStyle(
          //   //         fontFamily: FontName.poppinsSemiBold,
          //   //         fontSize: 18,
          //   //         fontWeight: FontWeight.bold,
          //   //         color: Color(0xff243444),
          //   //       ),
          //   //     ),
          //   //   ),
          //   //   leading: Builder(
          //   //     builder: (context) => Container(
          //   //       margin: const EdgeInsets.only(left: 5),
          //   //       child: IconButton(
          //   //         alignment: Alignment.centerLeft,
          //   //         icon: Image.asset(
          //   //           "assets/images/back.png",
          //   //           color: const Color(0xff000000),
          //   //           height: 21,
          //   //           width: 24,
          //   //         ),
          //   //         onPressed: () {
          //   //           ApiData.gridclickcount = 0;
          //   //           //  Navigator.pop(context);
          //   //           Navigator.of(context).push(MaterialPageRoute(
          //   //               builder: (context) => homedashboard(
          //   //                     savealiferep: _Repository,
          //   //                     accesstoken: accesstoken,
          //   //                     id: Prefs.getInt("userid")!,
          //   //                   )));
          //   //         },
          //   //       ),
          //   //     ),
          //   //   ),
          //   // ),
          //   body: GetHelpContent(
          //       gethelpmenucontent: gethelpmenucontent,
          //       gethelpfromBloc: _gethelpfromBloc),
          //   // bottomNavigationBar: FABBottomAppBar(
          //   //   centerItemText: '',
          //   //   color: Colors.grey,
          //   //   selectedColor: const Color.fromARGB(255, 12, 87, 216),
          //   //   notchedShape: const CircularNotchedRectangle(),
          //   //   onTabSelected: _selectedTab,
          //   //   items: [
          //   //     FABBottomAppBarItem(
          //   //         iconData:"assets/images/log_out.png", text: ''),
          //   //     FABBottomAppBarItem(
          //   //         iconData: "assets/images/user.png", text: ''),
          //   //   ],
          //   //   backgroundColor: Colors.white,
          //   // ),
          //   // floatingActionButtonLocation:
          //   //     FloatingActionButtonLocation.centerDocked,
          //   // floatingActionButton: _buildFab(
          //   //     context), // This trailing comma makes auto-formatting nicer for build methods.;
          // );
        });
  }

  // Widget _buildFab(BuildContext context) {
  //   return AnchoredOverlay(
  //     showOverlay: true,
  //     overlayBuilder: (context, offset) {
  //       return CenterAbout(
  //         position: Offset(offset.dx, offset.dy * 35.0),
  //         child: SizedBox(),
  //         // FabWithIcons(
  //         //   icons: icons,
  //         //   onIconTapped: _selectedFab,
  //         // ),
  //       );
  //     },
  //     child: FloatingActionButton(
  //       onPressed: () {},
  //       backgroundColor: Color.fromARGB(255, 12, 87, 216),
  //       child: Image.asset(
  //         "assets/images/home.png",
  //         height: 30,
  //         width: 30,
  //       ),
  //       elevation: 10.0,
  //     ),
  //   );
  // }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}

Widget showloading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

// class GetHelpFromPage extends StatefulWidget {
//
//   @override
//   _GetHelpFromPageState createState() => new _GetHelpFromPageState();
// }
//
// class _GetHelpFromPageState extends State<GetHelpFromPage>
//     with TickerProviderStateMixin {
//   String _lastSelected = 'TAB: 0';
//
//   final menu = [
//     {
//       'title': 'Fire',
//       'icon': 'assets/images/fire',
//       'color': ThemeColor.orange,
//     },
//     {
//       'title': 'Medical',
//       'icon': 'assets/images/medical',
//       'color': ThemeColor.red,
//     },
//     {
//       'title': 'Flood',
//       'icon': 'assets/images/flood',
//       'color': ThemeColor.lightBlue,
//     },
//     {
//       'title': 'Violence',
//       'icon': 'assets/images/violence',
//       'color': ThemeColor.darkPink,
//     },
//     {
//       'title': 'Landslide',
//       'icon': 'assets/images/landslide',
//       'color': ThemeColor.green,
//     },
//     {
//       'title': 'Winter Storm',
//       'icon': 'assets/images/storm',
//       'color': ThemeColor.darkGray,
//     },
//   ];
//
//   void _selectedTab(int index) {
//     setState(() {
//       _lastSelected = 'TAB: $index';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color(0xfff9fdfe),
//       appBar: AppBar(
//         toolbarHeight: 75,
//
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: Color(0xfff9fdfe),
//           systemNavigationBarIconBrightness: Brightness.light,
//           statusBarIconBrightness: Brightness.dark,
//           statusBarBrightness: Brightness.light,
//         ),
//         backgroundColor: Color(0xfff9fdfe),
//         elevation: 0,
//         centerTitle: false,
//         title: Transform(
//           // you can forcefully translate values left side using Transform
//           transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
//           child: const Text(
//             'Get Help From',
//             softWrap: false,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontFamily: FontName.poppinsSemiBold,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xff243444),
//             ),
//           ),
//         ),
//         leading: Builder(
//           builder: (context) => Container(
//             margin: const EdgeInsets.only(left: 5),
//             child: IconButton(
//               alignment: Alignment.centerLeft,
//               icon: Image.asset(
//                 "assets/images/back.png",
//                 color: const Color(0xff000000),
//                 height: 21,
//                 width: 24,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ),
//       ),
//       body: Center(child:
//       // Text(
//       //   _lastSelected,
//       //   style: TextStyle(fontSize: 32.0),
//       // ),
//       LayoutBuilder(builder: (context, constraints) {
//         return GridView.builder(
//           physics: NeverScrollableScrollPhysics(), //const ScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: menu.length,
//           scrollDirection: Axis.vertical,
//           padding: const EdgeInsets.all(15),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisSpacing: 15,
//             mainAxisSpacing: 10,
//             childAspectRatio: 2,
//             mainAxisExtent: 150,
//             crossAxisCount: 3,
//           ),
//           itemBuilder: (BuildContext context, int index) {
//             return GestureDetector(
//               child: _cellItem(context, menu[index]),
//               //onTap: () => ,
//             );
//           },
//         );
//       })),
//       bottomNavigationBar: FABBottomAppBar(
//         centerItemText: '',
//         color: Colors.grey,
//         selectedColor: Color.fromARGB(255, 12, 87, 216),
//         notchedShape: CircularNotchedRectangle(),
//         onTabSelected: _selectedTab,
//         items: [
//           // FABBottomAppBarItem(iconData: Icons.bookmark, text: ''),
//           // FABBottomAppBarItem(iconData: Icons.person, text: ''),
//           FABBottomAppBarItem(iconData: "assets/images/bookmark.png", text: ''),
//           FABBottomAppBarItem(iconData: "assets/images/user.png", text: ''),
//         ], backgroundColor: Colors.white,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: _buildFab(
//           context), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   Widget _cellItem(BuildContext context, Map data) {
//     return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             alignment: Alignment.center,
//             // width: 118,
//             constraints: const BoxConstraints(
//               maxHeight: 110, //double.infinity,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               // border: Border.all(width: 1, color: const Color(0xffF3F3F3)),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0xffB4B4B4),
//                   blurRadius: 5.0,
//                 ),
//               ],
//               color: data['color'].withOpacity(1.0),
//             ),
//
//             child: Image.asset(
//               data['icon'] + ".png",
//               height: 70,
//               width: 70,
//             ),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Padding(
//             padding: EdgeInsets.all(5),
//             child: Text(
//               data['title'],
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff111111),
//                   fontFamily: FontName.poppinsMedium),
//             ),
//           )
//         ]);
//   }
//
//   Widget _buildFab(BuildContext context) {
//     return AnchoredOverlay(
//       showOverlay: true,
//       overlayBuilder: (context, offset) {
//         return CenterAbout(
//           position: Offset(offset.dx, offset.dy * 35.0),
//           child: SizedBox(),
//           // FabWithIcons(
//           //   icons: icons,
//           //   onIconTapped: _selectedFab,
//           // ),
//         );
//       },
//       child: FloatingActionButton(
//         onPressed: () {
//           Navigator.pop(context);
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) =>  SALHome()),
//           // );
//         },
//         backgroundColor: Color.fromARGB(255, 12, 87, 216),
//         child: Image.asset(
//           "assets/images/home.png",
//           height: 30,
//           width: 30,
//         ),
//         elevation: 10.0,
//       ),
//     );
//   }
// }
