import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:savealifedemoapp/bloc/Signin_bloc/signin_bloc.dart';
import 'package:savealifedemoapp/ui/Signup/Validation/validation_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repository/SaveALifeRepository.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../Signup/SignupPage.dart';

class Signinform extends StatefulWidget {
  late final SigninBloc signinBloc;
  int userid;

  Signinform({required this.signinBloc, required this.userid}) : super();

  @override
  State<Signinform> createState() => _SigninformState();
}

class _SigninformState extends State<Signinform> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool submit = false;

  SigninBloc get _signinbloc => widget.signinBloc;

  // Create storage
  final _storage = const FlutterSecureStorage();
  bool passwordHidden = true;

  // bool _savePassword = true;

  // // Read values
  // Future<void> _readFromStorage() async {
  //   _emailController.text = await _storage.read(key: "KEY_EMAIL") ?? '';
  //   _passwordController.text = await _storage.read(key: "KEY_PASSWORD") ?? '';
  // }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        submit = _emailController.text.isNotEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        submit = _passwordController.text.isNotEmpty;
      });
    });
    // _readFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _handleRememberme(bool? value) {
    print("Check Remember Me");
    _isChecked = value!;

    Prefs.setBool("remember_me", value);
    Prefs.setString('email', _emailController.text);
    Prefs.setString('password', _passwordController.text);

    setState(() {
      _isChecked = value;
    });
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
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Welcome back ! Login with your credentials",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff254fd5),
                                fontFamily: FontName.poppinsRegular),
                          ),
                          const SizedBox(
                            height: 30,
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
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                      //textcapitalization
                                      textCapitalization: TextCapitalization.none,
                                    // validator: validationProvider.validateUserName(value),
                                    //onChanged: (value) => _userName = value,
                                    onChanged: (String value) {
                                      validationProvider.validateEmail(value);
                                    },

                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        // labelText: 'Email Id',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: FontName.poppinsMedium),
                                        hintText: 'Enter your Email',
                                        errorText:
                                            validationProvider.email.error,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff254fd5),
                                                width: 1.5)),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 24.0,
                                            width: 24.0,
                                            child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      // Color(0xff8D0C18)),
                                                      Color(0xff254fd5)),
                                              child: Checkbox(
                                                  activeColor:
                                                      Color(0xff254fd5),
                                                  value: _isChecked,
                                                  // value: _savePassword,
                                                  onChanged: _handleRememberme
                                                  // onChanged: (bool? newValue) {
                                                  //   setState(() {
                                                  //     _savePassword = newValue!;
                                                  //   });
                                                  // }
                                                  ),
                                            )),
                                        SizedBox(width: 10.0),
                                        Text("Remember Me",
                                            style: TextStyle(
                                                color: Color(0xff646464),
                                                fontSize: 12,
                                                fontFamily:
                                                    FontName.poppinsRegular))
                                      ]),
                                ),
                                const SizedBox(
                                  height: 30,
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
                                        ? () async {
                                            print(
                                                "username:${_usernameController.text}");

                                            print(
                                                "password:${_passwordController.text}");
                                            // if (_formKey.currentState?.validate() ?? false) {
                                            //   if (_savePassword) {
                                            //     // Write values
                                            //     await _storage.write(key: "KEY_EMAIL", value: _emailController.text);
                                            //     await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
                                            //     print(_emailController.text);
                                            //     print(_passwordController.text);
                                            //     widget.signinBloc.add(
                                            //         LoginButtonPressed(
                                            //             email: _emailController.text,
                                            //             password:
                                            //             _passwordController.text));
                                            //   }
                                            // }
                                            final bool? isValid = _formKey
                                                .currentState
                                                ?.validate();
                                            if (isValid == true) {
                                              var _email =
                                                  Prefs.getString("email") ??
                                                      "";
                                              var _password =
                                                  Prefs.getString("password") ??
                                                      "";
                                              var _rememberMe = Prefs.getBool(
                                                      "remember_me") ??
                                                  false;

                                              print("_rememberMe:$_rememberMe");
                                              print("_email:$_email");
                                              print("_password:$_password");
                                              if (_rememberMe) {
                                                setState(() {
                                                  _isChecked = true;
                                                });
                                                _emailController.text =
                                                    _email ?? "";
                                                _passwordController.text =
                                                    _password ?? "";
                                              }

                                              // debugPrint(_emailController.text);
                                              //
                                              // debugPrint(_passwordController.text);
                                              print(_emailController.text);
                                              print(_passwordController.text);
                                              widget.signinBloc.add(
                                                  LoginButtonPressed(
                                                      email:
                                                          _emailController.text,
                                                      password:
                                                          _passwordController
                                                              .text));
                                              // widget.signinBloc.add(redirecttohomedashboard());

                                            }
                                          }
                                        : null,

                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FontName.poppinsMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Text.rich(TextSpan(
                                //   text: "New User? ",
                                //   style: const TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontFamily: FontName.poppinsRegular),
                                //   children: <TextSpan>[
                                //     TextSpan(
                                //         text: "Create Account",
                                //         style: const TextStyle(
                                //             color: Color(0xff254fd5),
                                //             decoration:
                                //                 TextDecoration.underline,
                                //             fontFamily: FontName.poppinsMedium),
                                //         recognizer: TapGestureRecognizer()
                                //           ..onTap = () {
                                //             Navigator.push(
                                //               context,
                                //               MaterialPageRoute(
                                //                   builder: (context) => SignupPage(
                                //                       repoSaveaLife:
                                //                           SaveaLifeRepository())),
                                //             );
                                //           }),
                                //   ],
                                // )),
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
}
