import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/ui/Signup/Validation/validation_provider.dart';

import '../../bloc/Signup_bloc/signup_bloc.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../Signin/SigninPage.dart';

class Signupform extends StatefulWidget {
  late final SignupBloc signupBloc;

  Signupform({required this.signupBloc}) : super();

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordHidden = true;
  String deviceID = '';
  bool submit = false;
  String _userEmail = '';
  String _userName = '';
  String? _mobile;
  String? _password;

  SignupBloc get _signupbloc => widget.signupBloc;

  @override
  void initState() {
    //widget.loginBloc = BlocProvider.of<LoginBloc>(context);
    //
    getDeviceDetails();
    _usernameController.addListener(() {
      setState(() {
        submit = _usernameController.text.isNotEmpty;
      });
    });
    _emailController.addListener(() {
      setState(() {
        submit = _emailController.text.isNotEmpty;
      });
    });
    _mobileController.addListener(() {
      setState(() {
        submit = _mobileController.text.isNotEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        submit = _passwordController.text.isNotEmpty;
      });
    });
  }

  // final Validator validatorviewModel = Validator();
  getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceID = build.androidId!;
        print("DEVICEID : ${deviceID}");

        Prefs.setString("deviceid", deviceID);

        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          // deviceName = data.name;
          // deviceVersion = data.systemVersion;
          deviceID = data.identifierForVendor!;
          print("iOS DEVICEID : ${deviceID}");
          Prefs.setString("deviceid", deviceID);

          // getDiscussionDatabymenuid(widget.currentmenuitem.menuId);
        }); //UUID for iOS
      }

      // print('Device Info: ${deviceName}, ${deviceVersion}, ${deviceID}');
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  @override
  Widget build(BuildContext context) {
    final validationProvider = Provider.of<ValidationProvider>(context);
    return Scaffold(
        backgroundColor: Color(0xfff9fdfe),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  //  height:702,
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Container(
                            // margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/images/logo192.png",
                                height: 150, width: 150, fit: BoxFit.fitWidth),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  //  height: 50,
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    keyboardType: TextInputType.name,

                                    // validator: validationProvider.validateUserName(value),
                                    //onChanged: (value) => _userName = value,
                                    onChanged: (String value) {
                                      validationProvider.validateName(value);
                                    },

                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff254fd5),
                                                width: 1.5)),
                                        // labelText: 'Email Id',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: FontName.poppinsMedium),
                                        hintText: 'Enter your Full Name',
                                        errorText:
                                            validationProvider.name.error,
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red))

                                        // errorText: texterror
                                        //     ? "Username length must be 7 or greater"
                                        //     : null,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  //   height: 50,
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    controller: _emailController,

                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    //  validator: validateEmail,
                                    //    onChanged: (value) =>
                                    //        _userEmail = value,
                                    onChanged: (String value) {
                                      validationProvider.validateEmail(value);
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff254fd5),
                                                width: 1.5)),
                                        // labelText: 'Email Id',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: FontName.poppinsMedium),
                                        hintText: 'Enter your Email',
                                        errorText:
                                            validationProvider.email.error,
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red))
                                        // errorText: texterror
                                        //     ? "Enter Correct Email Address"
                                        //     : null,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  //    height: 50,
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: TextFormField(
                                    obscureText: false,
                                    keyboardType: TextInputType.phone,
                                    //  textInputAction: TextInputAction.next,
                                    controller: _mobileController,
                                    //  maxLength: 10,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    //  validator: validateMobile,

                                    //  onChanged: (value) => _mobile = value,
                                    onChanged: (String value) {
                                      validationProvider
                                          .validateMobileNumber(value);
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff254fd5),
                                                width: 1.5)),
                                        // labelText: 'Password',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: FontName.poppinsMedium),
                                        hintText: 'Enter your Mobile Number',
                                        errorText:
                                            validationProvider.mobile.error,
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red))
                                        // errorText: texterror
                                        //     ? "Mobile Number must be of 10 digits"
                                        //     : null,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  //   height: 50,
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: passwordHidden,
                                    onChanged: (String value) {
                                      validationProvider
                                          .validatePassword(value);
                                    },
                                    enableSuggestions: false,
                                    decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              passwordHidden = !passwordHidden;
                                            });
                                          },
                                          child: Icon(
                                            passwordHidden
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: const Color(0xff747881),
                                            size: 23,
                                          ),
                                        ),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff254fd5),
                                                width: 1.5)),
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: FontName.poppinsMedium),
                                        hintText: 'Enter your Password',
                                        errorText:
                                            validationProvider.password.error,
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red))),
                                  ),
                                ),
                                // Container(
                                //   //   height: 50,
                                //   margin: const EdgeInsets.only(
                                //       left: 30, right: 30),
                                //   child: TextFormField(
                                //     controller: _passwordController,
                                //     textAlign: TextAlign.start,
                                //     keyboardType: TextInputType.visiblePassword,
                                //     obscureText: true,
                                //
                                //     //    validator: validationProvider.validatePassword(value),
                                //
                                //     //  validator: validationProvider.validateEmail(value),
                                //     // validator: (value) {
                                //     //   if (value == null ||
                                //     //       value.trim().isEmpty) {
                                //     //     return 'Password is required!';
                                //     //   }
                                //     //   if (value.trim().length < 6) {
                                //     //     return 'Password must be at least 6 characters in length!';
                                //     //   }
                                //     //   // Return null if the entered password is valid
                                //     //   return null;
                                //     // },
                                //     //   onChanged: (value) => _password = value,
                                //     onChanged: (String value) {
                                //       validationProvider
                                //           .validatePassword(value);
                                //     },
                                //     decoration: InputDecoration(
                                //         border: OutlineInputBorder(),
                                //         hintStyle: TextStyle(
                                //             fontSize: 14,
                                //             fontFamily: FontName.poppinsMedium),
                                //         hintText: 'Enter your Password',
                                //         focusedBorder: OutlineInputBorder(
                                //             borderSide: const BorderSide(
                                //                 color:  Color(0xff254fd5))) ,
                                //         errorText:
                                //             validationProvider.password.error,
                                //         errorBorder: OutlineInputBorder(
                                //             borderSide: const BorderSide(
                                //                 color: Colors.red))),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  height: 40,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xff254fd5),
                                        elevation: 3,
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontStyle: FontStyle.normal),
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        padding: const EdgeInsets.all(5)),
                                    // onPressed: (!validationProvider.isValid)?null:validationProvider.sumbitData ,
                                    onPressed: submit
                                        ? () {
                                            print(
                                                "username:${_usernameController.text}");
                                            print(
                                                "email:${_emailController.text}");
                                            print(
                                                "mobile_number:${_mobileController.text}");
                                            print(
                                                "password:${_passwordController.text}");
                                            //
                                            // Provider.of<SignupValidationProvider>(context,
                                            //         listen: false)
                                            //     .signIn(_userName, _userEmail,
                                            //
                                            //
                                            //         _mobile!);

                                            final bool? isValid = _formKey
                                                .currentState
                                                ?.validate();
                                            if (isValid == true) {
                                              debugPrint(
                                                  _usernameController.text);
                                              debugPrint(_emailController.text);
                                              debugPrint(
                                                  _mobileController.text);
                                              debugPrint(
                                                  _passwordController.text);
                                              widget.signupBloc
                                                  .add(SignUpButtonPressed(
                                                username:
                                                    _usernameController.text,
                                                email: _emailController.text,
                                                mobileNumber:
                                                    _mobileController.text,
                                                password:
                                                    _passwordController.text,
                                                deviceID: deviceID,
                                              ));
                                            }
                                          }
                                        : null,

                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FontName.poppinsMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text.rich(TextSpan(
                                  text: "Already have an account? ",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: FontName.poppinsRegular),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Login",
                                        style: const TextStyle(
                                            color: Color(0xff254fd5),
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: FontName.poppinsMedium),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SigninPage(
                                                      saveliferepo:
                                                          SaveaLifeRepository())),
                                            );
                                          }),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
    ;
  }

  String? validateName(String? value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.isEmpty) {
      return "Name is Required!";
    } else if (value.trim().length < 7) {
      return "Username must be at least 7 characters in length!";
    }
    /*else if(!regExp.hasMatch(value)) {
      return "Username is not matching pattern";
    }*/
    return null;
  }

  String? validateMobile(String? value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return "Mobile is Required!";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits!";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits!";
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Email is Required!";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email!";
    } else {
      return null;
    }
  }
}
