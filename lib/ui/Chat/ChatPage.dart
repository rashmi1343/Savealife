import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savealifedemoapp/utils/Constant.dart';
import 'package:flutter/material.dart';

import '../../Model/GetAllUsersResponse.dart';
import '../../Repository/SaveALifeRepository.dart';
import '../../bloc/User_bloc/user_bloc.dart';
import '../../bloc/User_bloc/user_event.dart';
import '../../bloc/User_bloc/user_state.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../HomeDashboard/homedashboard.dart';
import 'ChatAllUsers.dart';

class ChatPage extends StatefulWidget {
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  int id;

  @override
  ChatPage(
      {required this.savealiferep, required this.accesstoken, required this.id})
      : assert(savealiferep != null),
        super();

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 1;
  late UserBloc userBloc;

  late String accesstoken;

  SaveaLifeRepository get _Repository => widget.savealiferep;

  late List<User> userslist = [];

  late String devtoken;

  @override
  void initState() {
    super.initState();
    print("chat page called");
    accesstoken = widget.accesstoken.toString();
    print("chat page access token:$accesstoken");
    userBloc = UserBloc(
      saveaLifeRepository: _Repository,
      accesstoken: accesstoken,
      id: widget.id,
    );

    userBloc.add(FetchUserEvent());
   // BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To Homedashboard Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
    if (["homedashboardRoute"].contains(info.currentRoute(context))) return true;
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => homedashboard(
    //       savealiferep: _Repository,
    //       accesstoken: accesstoken,
    //       id: widget.id,
    //     )));
    // if (["docRoute"].contains(info.currentRoute(context))) return true;

    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
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

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        homedashboard(
          savealiferep: SaveaLifeRepository(),
          accesstoken: Prefs.getString("accesstoken").toString(),
          id: Prefs.getInt("userid")!,
        )), (Route<dynamic> route) => false);
    return true;
  }
  @override
  Widget build(BuildContext context) {
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
          }
          if (state is SendMessageNotificationSuccessState) {
            print("Response:" + state.notificationResponse.toString());
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
                title: AppBarTitle('Chat'),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => homedashboard(
                              savealiferep: _Repository,
                              accesstoken: accesstoken,
                              id: widget.id,
                            )));
                      },
                    ),
                  ),
                ),
              ),
              body: ChatAllUsers(
                userslist: userslist,
                accesstoken: widget.accesstoken,
                userBloc: userBloc,
              ),
            ),
          );
        });
  }

  Widget showloading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
