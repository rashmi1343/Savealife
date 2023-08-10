import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savealifedemoapp/ui/SettingPage.dart';
import 'package:savealifedemoapp/ui/Signin/SigninPage.dart';

import '../../Repository/SaveALifeRepository.dart';
import '../../bloc/Signin_bloc/signin_bloc.dart';
import '../../bloc/Signup_bloc/signup_bloc.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../Signup/SignupPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int splashtime = 3;
  int issignup = 0;


  @override
  void initState() {
    bool? isSignup = Prefs.getBool("IsSignup");
    if (isSignup == true) {
      issignup = 1;
    } else {
      issignup = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.asset("assets/images/logo1024.png")),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50,
            width: 320,
            margin: EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              child: issignup == 0
                  ? Text(
                      'Activate your Account',
                      style: TextStyle(fontSize: 18),
                    )
                  : Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xff254fd5),
                  elevation: 3,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: FontName.poppinsBold,
                  ),
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.all(5)),
              onPressed: () {
                if (issignup == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                        create: (context) => SignupBloc(
                            saveALiferepository: SaveaLifeRepository()),
                        child:
                            SignupPage(repoSaveaLife: SaveaLifeRepository()));
                  }));
                } else if (issignup == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                        create: (context) => SigninBloc(
                            saveALiferepository: SaveaLifeRepository()),
                        child: SigninPage(saveliferepo: SaveaLifeRepository()));
                  }));
                }
              },
            ),
          ),
        ),
      ])),
    );
  }
}
