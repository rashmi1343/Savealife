import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savealifedemoapp/bloc/Otp_bloc/otp_bloc.dart';
import 'package:savealifedemoapp/ui/HomeDashboard/homedashboard.dart';
import 'package:savealifedemoapp/ui/Otp/Otpform.dart';
import 'package:savealifedemoapp/ui/Profile/Profilebasepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repository/SaveALifeRepository.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';

class OtpPage extends StatefulWidget {
  SaveaLifeRepository saveliferepo;
  String? mobileno;
  String email;
  String password;
  int otp;
  int userid;

  OtpPage(
      {required this.mobileno,
      required this.email,
      required this.password,
      required this.otp,
      required this.saveliferepo,
      required this.userid})
      : super();

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late OtpBloc _otpbloc;
  int userid = 0;
  String token = "";

  SaveaLifeRepository get _Repository => widget.saveliferepo;
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      return  Timer(_duration, navigationPageHome);
    } else {// First time
      prefs.setBool('first_time', false);
      return  Timer(_duration, navigationProfilePageWel);
    }
  }
  void navigationPageHome() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => homedashboard(
            savealiferep: _Repository,
            accesstoken: token,
            id: userid)));
  }

  void navigationProfilePageWel() {

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Profilebasepage(
            Reposavealife: _Repository,
            accesstoken: token,
            userid: userid)));
  }
  @override
  void initState() {
    // call signin api
    // _otpbloc = OtpBloc(
    //     savealiferepo: _Repository,
    //     email: widget.email,
    //     password: widget.password);
    _otpbloc = OtpBloc(
        savealiferepo: _Repository, id: widget.userid, otp: widget.otp,email: widget.email, password: widget.password
        );
   // _otpbloc.add(otpverifyevent(id: widget.userid, otp: widget.otp));
//  _otpbloc.add(otpsignin(email: widget.email, password: widget.password));

    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To Signup Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
    // if (["docRoute"].contains(info.currentRoute(context))) return true;

    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return Container();
    return BlocBuilder<OtpBloc, OtpState>(
        bloc: _otpbloc,
        builder: (BuildContext context, OtpState state) {
          if (state is otpsignin) {
            print("otpsignin in process");
          }
          if (state is otpinitialState) {
            print("otpScreen open");
          }

          if (state is otpvalidationState) {
            print("otpScreen validation issue");
          }

          if (state is otpverifyfailurestate) {
            print("otpScreen otp verification issue");
          }
          if (state is otpgettokenstate) {
            print("redirect to menu screen");
            print("received token");
            userid = state.lgresponse.id!;
            token = state.lgresponse.accessToken;
            print("userid" + userid.toString());
            _onWidgetDidBuild(() {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => homedashboard(
              //         savealiferep: _Repository,
              //         accesstoken: token,
              //         id: userid)));
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //         builder: (context) => homedashboard(
              //           savealiferep: _Repository,
              //           accesstoken: token,
              //           id: userid,
              //         )),
              //         (Route<dynamic> route) => false);
              startTime();
            });
          }
          if (state is otpVerifyState) {
            print("Verified otp");

            Fluttertoast.showToast(
              msg: state.verifyOtpResponse.message,
              backgroundColor:  Color(0xff254fd5),
            );
          }


          return Scaffold(
              backgroundColor: Color(0xfff9fdfe),
              appBar: AppBar(
                centerTitle: false,
                toolbarHeight: 75,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.light,
                ),
                backgroundColor: Color(0xfff9fdfe),
                elevation: 0,
                title: Text(
                  "Confirm OTP",
                  style: const TextStyle(
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
                        ApiData.gridclickcount = 0;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              body: Otpform(
                  mobileno: widget.mobileno,
                  otp: widget.otp,
                  email:widget.email,
                  password:widget.password,
                  otpbloc: _otpbloc,
                  userid: userid));
        });
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
