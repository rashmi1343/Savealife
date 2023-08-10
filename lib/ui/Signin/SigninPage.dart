import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';

import 'package:savealifedemoapp/ui/Otp/OtpPage.dart';
import 'package:savealifedemoapp/ui/Signin/Signinform.dart';
import 'package:savealifedemoapp/ui/Signup/Signupform.dart';
import 'package:savealifedemoapp/utils/pref.dart';

import '../../bloc/Homedashboard_bloc/homedashboard_bloc.dart';
import '../../bloc/Signin_bloc/signin_bloc.dart';
import '../../bloc/Signup_bloc/signup_bloc.dart';
import '../../main.dart';
import '../../utils/CustomTextStyle.dart';
import '../HelpRequest/HelpRequest.dart';
import '../HomeDashboard/homedashboard.dart';
import '../Profile/ProfilePage.dart';

class SigninPage extends StatefulWidget {
  // SaveaLifeRepository saveliferepo;
  //
  // String username;
  // String password;
  // int? otp;
  // int? userid;
  // SigninPage({required this.username, required this.password, required this.saveliferepo})
  //     : assert(saveliferepo != null),
  //       super();

  final SaveaLifeRepository saveliferepo;
  // String username;
  // String password;

  //int otp;

  SigninPage(
      {required this.saveliferepo,
    })
      : assert(saveliferepo != null),
        super();

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late SigninBloc _signinbloc;

  int userid = 0;
  String? username ;
  String? email ;
  String? mobile ;
  String token = "";

  SaveaLifeRepository get _Repository => widget.saveliferepo;

  @override
  void initState() {
    _signinbloc = SigninBloc(
      saveALiferepository: _Repository,

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return BlocBuilder<SigninBloc, SigninState>(
        bloc: _signinbloc,
        builder: (
          BuildContext context,
          SigninState state,
        ) {
          if (state is signingettokenstate) {
            print("received token");
            userid = state.lgresponse.id!;
            username = state.lgresponse.username!;
            email = state.lgresponse.email!;
            mobile = state.lgresponse.mobile!;
            token = state.lgresponse.accessToken;

            Prefs.setString("accesstoken", token);
            Prefs.setString("username", username!);
            Prefs.setString("email", email!);
            Prefs.setInt("userid", userid);
            Prefs.setString("mobile", mobile!);


            print("userid" + userid.toString());
              _onWidgetDidBuild(() {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => HelpRequest()));

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => homedashboard(
                        savealiferep: _Repository,
                        accesstoken: token,
                        id: userid)));
              });


          }
          // if (state is SigninredirectState) {
          //   print("navigate to homedashboard page");
          //   _onWidgetDidBuild(() {
          //
          //
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => homedashboard(
          //             savealiferep: _Repository,
          //             accesstoken: token,
          //             id: userid)));
          //   });
          // }

          if (state is SigninfailureState) {
            print("failure");
          }

          return WillPopScope(
            onWillPop: ()async{
              return false;
            },
            child: Scaffold(
                backgroundColor: Color(0xfff9fdfe),
                appBar: AppBar(
                  centerTitle: true,
                  toolbarHeight: 75,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.black,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.light,
                  ),
                  backgroundColor: Color(0xfff9fdfe),
                  elevation: 0,
                  title: const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: FontName.poppinsSemiBold,
                      fontSize: 17,
                      color: Color(0xff243444),
                    ),
                  ),
                  // leading: Builder(
                  //   builder: (context) => Container(
                  //     margin: const EdgeInsets.only(left: 10),
                  //     child: IconButton(
                  //       alignment: Alignment.centerLeft,
                  //       icon: Image.asset(
                  //         "assets/images/back.png",
                  //         color: const Color(0xff000000),
                  //         height: 21,
                  //         width: 24,
                  //       ),
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //   ),
                  // ),
                ),
                body: Signinform(
                  signinBloc: _signinbloc, userid: userid,
                )),
          );
        });
  }
}

void _onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
