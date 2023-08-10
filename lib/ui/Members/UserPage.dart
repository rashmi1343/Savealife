import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/ui/GetHelpFrom/GetHelpMenuPage.dart';

import '../../Model/GetAllUsersResponse.dart';

import '../../bloc/User_bloc/user_bloc.dart';
import '../../bloc/User_bloc/user_event.dart';
import '../../bloc/User_bloc/user_state.dart';
import '../../utils/Constant.dart';
import '../../utils/pref.dart';
import '../HomeDashboard/homedashboard.dart';
import '../NavigationBar/fab_bottom_app_bar.dart';
import '../NavigationBar/layout.dart';
import 'MemberContent.dart';

class UserPage extends StatefulWidget {
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  int id;

  @override
  UserPage(
      {required this.savealiferep, required this.accesstoken, required this.id})
      : assert(savealiferep != null),
        super();

  @override
  State<UserPage> createState() => _UserState();
}

class _UserState extends State<UserPage> {
  late UserBloc userBloc;

  late String accesstoken;

  SaveaLifeRepository get _Repository => widget.savealiferep;

  late List<User> userslist = [];

  String? usersendername;

  @override
  void initState() {
    super.initState();
    print("user page called");
    accesstoken = widget.accesstoken.toString();
    print("user page access token$accesstoken");
    userBloc = UserBloc(
      saveaLifeRepository: _Repository,
      accesstoken: accesstoken,
      id: widget.id,
    );

    userBloc.add(FetchUserEvent());
  //  BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To gethelpdashboardRoute Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
    Navigator.pop(context);
   // if (["gethelpdashboardRoute"].contains(info.currentRoute(context))) return true;
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => homedashboard(
    //       savealiferep: _Repository,
    //       accesstoken: accesstoken, id: widget.id,
    //
    //     )));

    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    void _selectedTab(int index) {
      setState(() {
        var _lastSelected = 'TAB: $index';
      });
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

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          homedashboard(
            savealiferep: SaveaLifeRepository(),
            accesstoken: Prefs.getString("accesstoken").toString(),
            id: Prefs.getInt("userid")!,
          )), (Route<dynamic> route) => false);
      return true;
    }
    return BlocBuilder<UserBloc, UserState>(
        bloc: userBloc,
        builder: (BuildContext context, UserState state) {
          if (state is UserLoadingState) {
            showloading();
          }
          if (state is loadedUserSuccessState) {
            print("Users loaded ");
            userslist = state.userDataArr;


            print("userlist length:$userslist");
            usersendername=state.userDataArr[0].username;

            Prefs.setString("usersendername",usersendername!);
          }

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: const Color(0xfff9fdfe),
              appBar: AppBar(
                toolbarHeight: 75,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.black, // <-- SEE HERE
                  statusBarIconBrightness:
                      Brightness.light, //<-- For Android SEE HERE (dark icons)
                  statusBarBrightness:
                      Brightness.light, //<-- For iOS SEE HERE (dark icons)
                ),
                backgroundColor: const Color(0xfff9fdfe),
                elevation: 0,
                centerTitle: false,
                title: AppBarTitle('Members'),
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
                        ApiData.gridclickcount = 0;
                        Navigator.pop(context);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => GetHelpMenuPage(
                        //       savealiferep: _Repository,
                        //       accesstoken: accesstoken, userid: widget.id,
                        //
                        //     )));
                      },
                    ),
                  ),
                ),
              ),
              body: MemberContent(
                userslist: userslist,
                accesstoken: widget.accesstoken,
                userBloc: userBloc,
              ),
              // bottomNavigationBar: FABBottomAppBar(
              //   centerItemText: '',
              //   color: Colors.grey,
              //   selectedColor: const Color.fromARGB(255, 12, 87, 216),
              //   notchedShape: const CircularNotchedRectangle(),
              //   onTabSelected: _selectedTab,
              //   items: [
              //     FABBottomAppBarItem(
              //         iconData:"assets/images/log_out.png", text: ''),
              //     FABBottomAppBarItem(
              //         iconData: "assets/images/user.png", text: ''),
              //   ],
              //   backgroundColor: Colors.white,
              // ),
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerDocked,
              // floatingActionButton: _buildFab(context),
            ),
          );
        });
  }

  Widget showloading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFab(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy * 35.0),
          child: SizedBox(),
          // FabWithIcons(
          //   icons: icons,
          //   onIconTapped: _selectedFab,
          // ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 12, 87, 216),
        child: Image.asset(
          "assets/images/home.png",
          height: 30,
          width: 30,
        ),
        elevation: 10.0,
      ),
    );
  }
}
