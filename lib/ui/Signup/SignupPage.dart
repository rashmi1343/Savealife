import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/ui/Otp/OtpPage.dart';
import 'package:savealifedemoapp/ui/Signup/Signupform.dart';

import '../../bloc/Signup_bloc/signup_bloc.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../Profile/ProfilePage.dart';
import '../Signin/SigninPage.dart';

class SignupPage extends StatefulWidget {
  final SaveaLifeRepository repoSaveaLife;

  SignupPage({required this.repoSaveaLife})
      : assert(repoSaveaLife != null),
        super();

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late SignupBloc _signupbloc;

  late String username;
  late String email;
  late String password;
  late String mobileno;

  SaveaLifeRepository get _Repository => widget.repoSaveaLife;

  @override
  void initState() {
    _signupbloc = SignupBloc(saveALiferepository: _Repository);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return BlocBuilder<SignupBloc, SignupState>(
        bloc: _signupbloc,
        builder: (BuildContext context, SignupState state) {
          if (state is SignupRegisterState) {
            print("Sign up in process");
            username = state.username;
            email = state.email;
            password = state.password;
            mobileno = state.mobileno;
          }

          if (state is SignupSuccessState) {
            print("navigate to otp Screen");
            Prefs.setInt("userid", state.signUpResponse.id);
            Prefs.setString("username", state.signUpResponse.username);
            Prefs.setString("email", state.signUpResponse.email);
            Prefs.setString("mobile", state.signUpResponse.mobile);
            _onWidgetDidBuild(() {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) =>  SigninPage(saveliferepo: widget.repoSaveaLife,otp:state.signUpResponse.otp)),
              // );
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ProfilePage(
              //       )));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OtpPage(
                      mobileno: mobileno,
                      email: email,
                      password: password,
                      otp: state.signUpResponse.otp,
                      saveliferepo: _Repository,
                      userid: Prefs.getInt("userid")!.toInt())));
            });
          }

          return Scaffold(
              backgroundColor: Color(0xfff9fdfe),
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: false,
                toolbarHeight: 75,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  // <-- SEE HERE
                  statusBarIconBrightness: Brightness.light,
                  //<-- For Android SEE HERE (dark icons)
                  statusBarBrightness:
                      Brightness.light, //<-- For iOS SEE HERE (dark icons)
                ),
                backgroundColor: Color(0xfff9fdfe),
                elevation: 0,
                title: const Text(
                  "Activate Account",
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              body: Signupform(signupBloc: _signupbloc));
        });
  }
}

void _onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
