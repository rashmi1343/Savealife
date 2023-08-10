import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/ui/GetHelpFrom/GetHelpMenuPage.dart';

import 'dart:ui' as ui;
import '../../Model/GetAllUsersResponse.dart';

import '../../bloc/User_bloc/user_bloc.dart';
import '../../bloc/User_bloc/user_state.dart';
import '../../bloc/User_bloc/user_event.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../NavigationBar/fab_bottom_app_bar.dart';
import '../NavigationBar/layout.dart';
import 'MapViewRoute.dart';
import 'UsermapContent.dart';

class UsermapPage extends StatefulWidget {
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  int userid;

  @override
  UsermapPage({
    super.key,
    required this.savealiferep,
    required this.accesstoken,
    required this.userid,
  });

  @override
  State<UsermapPage> createState() => _UsermapPageState();
}

class _UsermapPageState extends State<UsermapPage> {
  late UserBloc _userBloc;

  // late SendHelpBloc _sendHelpBloc;

  SaveaLifeRepository get _Repository => widget.savealiferep;

  late List<User> userslist = [];

  @override
  void initState() {
    _userBloc = UserBloc(
        saveaLifeRepository: _Repository,
        accesstoken: widget.accesstoken,
        id: widget.userid);
    // _sendHelpBloc = SendHelpBloc(
    //     saveALiferepository: SaveaLifeRepository(),
    //     accesstoken: widget.accesstoken);
    super.initState();
    // accesstoken = widget.accesstoken.toString();
    BlocProvider.of<UserBloc>(context).add(FetchUserEvent());

    //   _sendHelpBloc = BlocProvider.of<SendHelpBloc>(context);
    //  BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To gethelpdashboard Page");
    //  Navigator.pop(context);
    // ApiData.gridclickcount = 0;
    // if (["gethelpdashboardRoute"].contains(info.currentRoute(context)))
    //   return true;

    ApiData.gridclickcount = 0;
    // Navigator.pushNamed(context, '/gethelpdashboardRoute');
    Navigator.pop(context);
    /* Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GetHelpMenuPage(
          savealiferep: SaveaLifeRepository(),
          accesstoken:
          Prefs.getString("accesstoken").toString(),
          userid: Prefs.getInt("userid")!,
        )));*/
    return true;
  }

  @override
  void dispose() {
    //  BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    print("back called");

    /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return homedashboard(
                savealiferep: widget.savealiferep,
                accesstoken:widget.accesstoken,
                 id: Prefs.getInt("userid")!,
               );
             }));*/

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => GetHelpMenuPage(
                  savealiferep: widget.savealiferep,
                  accesstoken: widget.accesstoken,
                  userid: Prefs.getInt("userid")!,
                )),
        (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    void _selectedTab(int index) {
      setState(() {
        var _lastSelected = 'TAB: $index';
      });
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          extendBody: true,
          backgroundColor: const Color(0xfff9fdfe),
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
              "Searching People",
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
                    // Navigator.pop(context);
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
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoadingState) {
                print("map loading state");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is loadedUserSuccessState) {
                print(state);
                userslist = state.userDataArr;

                return UsermapContent(
                    userslist: userslist,
                    accesstoken: widget.accesstoken,
                    userBloc: _userBloc
                    // userBloc: userBloc,
                    );
              }

              // if (state is SendHelpRequestSucessState) {
              //   print("send help request success state");
              //  // _onWidgetDidBuild(() {
              //  return   SnackBar(
              //       backgroundColor: const ui.Color.fromARGB(255, 215, 36, 23),
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
              //       duration: const Duration(seconds: 100),
              //       behavior: SnackBarBehavior.floating,
              //     );
              //  // });
              //
              //   // WidgetsBinding.instance.addPostFrameCallback(
              //   //       (_) => ScaffoldMessenger.of(context)
              //   //     ..removeCurrentSnackBar()
              //   //     ..showSnackBar(
              //   //       SnackBar(
              //   //         backgroundColor: const ui.Color.fromARGB(255, 215, 36, 23),
              //   //         content: Row(
              //   //           children: const [
              //   //             Icon(
              //   //               color: Colors.white,
              //   //               Icons.warning,
              //   //             ),
              //   //             SizedBox(
              //   //               width: 10,
              //   //             ),
              //   //             Text(
              //   //               'Waiting for Confirmation...',
              //   //               style: TextStyle(
              //   //                 fontSize: 14,
              //   //                 fontFamily: FontName.poppinsMedium,
              //   //               ),
              //   //             )
              //   //           ],
              //   //         ),
              //   //         duration: const Duration(seconds: 5),
              //   //         behavior: SnackBarBehavior.floating,
              //   //       ),
              //   //     ),
              //   // );
              // }

              return Container();
            },
          ),
          // bottomNavigationBar: FABBottomAppBar(
          //   centerItemText: '',
          //   color: Colors.grey,
          //   selectedColor: const Color.fromARGB(255, 12, 87, 216),
          //   notchedShape: const CircularNotchedRectangle(),
          //   onTabSelected: _selectedTab,
          //   items: [
          //     FABBottomAppBarItem(iconData: "assets/images/log_out.png", text: ''),
          //     FABBottomAppBarItem(iconData: "assets/images/user.png", text: ''),
          //   ],
          //   backgroundColor: Colors.white,
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: _buildFab(context),
        ));
  }

  // return BlocBuilder<UserBloc, UserState>(
  //     bloc: userBloc,
  //     builder: (BuildContext context, UserState state) {
  //       if (state is UserLoadingState) {
  //         showloading();
  //       }
  //       if (state is loadedUserSuccessState) {
  //         print(state);
  //         userslist = state.userDataArr;
  //       }

  //       return Scaffold(
  //         extendBody: true,
  //         backgroundColor: const Color(0xfff9fdfe),
  //         appBar: commonAppBar("Searching People"),
  //         body: UsermapContent(
  //           userslist: userslist,
  //           accesstoken: widget.accesstoken,
  //           userBloc: userBloc,
  //         ),
  //         bottomNavigationBar: FABBottomAppBar(
  //           centerItemText: '',
  //           color: Colors.grey,
  //           selectedColor: const Color.fromARGB(255, 12, 87, 216),
  //           notchedShape: const CircularNotchedRectangle(),
  //           onTabSelected: _selectedTab,
  //           items: [
  //             FABBottomAppBarItem(
  //                 iconData: "assets/images/bookmark.png", text: ''),
  //             FABBottomAppBarItem(
  //                 iconData: "assets/images/user.png", text: ''),
  //           ],
  //           backgroundColor: Colors.white,
  //         ),
  //         floatingActionButtonLocation:
  //             FloatingActionButtonLocation.centerDocked,
  //         floatingActionButton: _buildFab(context),
  //       );
  //     });
  // }

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

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
