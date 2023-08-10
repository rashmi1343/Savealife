import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savealifedemoapp/Model/LoginResponse.dart';

import '../../bloc/Otp_bloc/otp_bloc.dart';
import '../../utils/CustomTextStyle.dart';

class Otpform extends StatefulWidget {
  String? mobileno;
  int otp;
  late final OtpBloc otpbloc;
  int userid;
  String email;
  String password;

  Otpform(
      {required this.mobileno,
      required this.otp,
      required this.otpbloc,
      required this.userid,
        required this.email,
        required this.password})
      : super();

  @override
  State<Otpform> createState() => _OtpFormState();
}

class _OtpFormState extends State<Otpform> {
  TextEditingController otpController = TextEditingController();

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  String? _otp;
  String currentText = "";
  String? _verificationCode;
  bool submit = false;
  OtpBloc get _otpBloc => widget.otpbloc;

  @override
  void initState() {
    super.initState();
    _fieldOne.addListener(() {
      setState(() {
        submit = _fieldOne.text.isNotEmpty;
      });
    });
    _fieldTwo.addListener(() {
      setState(() {
        submit = _fieldTwo.text.isNotEmpty;
      });
    });
    _fieldThree.addListener(() {
      setState(() {
        submit = _fieldThree.text.isNotEmpty;
      });
    });
    _fieldFour.addListener(() {
      setState(() {
        submit = _fieldFour.text.isNotEmpty;
      });
    });
    _fieldFive.addListener(() {
      setState(() {
        submit = _fieldFive.text.isNotEmpty;
      });
    });
    _fieldSix.addListener(() {
      setState(() {
        submit = _fieldSix.text.isNotEmpty;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fdfe),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // height: 800,
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset("assets/images/logo192.png",
                        height: 150, width: 150, fit: BoxFit.fitWidth),
                  ),
                  Column(
                    children: [
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Enter OTP Send To ',
                              style: const TextStyle(
                                fontFamily: FontName.poppinsMedium,
                                fontSize: 14,
                                color: Color(0xffd8d8d8),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.mobileno,
                                    style: TextStyle(
                                      color: Color(0xff254fd5),
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 14,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                      })
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OtpInput(
                            controller: _fieldOne,
                            first: true,
                            last: false,
                          ), // auto focus
                          OtpInput(
                            controller: _fieldTwo,
                            first: false,
                            last: false,
                          ), // auto focus
                          OtpInput(
                            controller: _fieldThree,
                            first: false,
                            last: false,
                          ), // auto focus
                          OtpInput(
                            controller: _fieldFour,
                            first: false,
                            last: false,
                          ), // auto focus
                          OtpInput(
                            controller: _fieldFive,
                            first: false,
                            last: false,
                          ), // auto focus
                          OtpInput(
                            controller: _fieldSix,
                            first: false,
                            last: true,
                          ), // auto focus
                        ],
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(30),
                      //   child: Center(
                      //     child: PinCodeTextField(
                      //       length: 6,
                      //       obscureText: true,
                      //       animationType: AnimationType.fade,
                      //       pinTheme: PinTheme(
                      //         shape: PinCodeFieldShape.box,
                      //         borderRadius: BorderRadius.circular(5),
                      //         fieldHeight: 50,
                      //         fieldWidth: 45,
                      //        // activeFillColor: Colors.white,
                      //       ),
                      //       animationDuration: const Duration(milliseconds: 300),
                      //      // backgroundColor: Colors.blue.shade50,
                      //      // enableActiveFill: true,
                      //       controller: otpController,
                      //       onCompleted: (v) {
                      //         debugPrint("Completed");
                      //       },
                      //       onChanged: (value) {
                      //         debugPrint(value);
                      //         setState(() {
                      //           currentText = value;
                      //         });
                      //       },
                      //       beforeTextPaste: (text) {
                      //         return true;
                      //       },
                      //       appContext: context,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.all(10),
                      //   child:    OtpTextField(
                      //     numberOfFields: 6,
                      //     borderColor: Color(0xFF512DA8),
                      //     fieldWidth: 50,
                      //
                      //     showFieldAsBox: true,
                      //
                      //     onCodeChanged: (String code) {
                      //       //handle validation or checks here
                      //     },
                      //     //runs when every textfield is filled
                      //     onSubmit: (String verificationCode){
                      //       showDialog(
                      //           context: context,
                      //           builder: (context){
                      //             return AlertDialog(
                      //               title: Text("Verification Code"),
                      //               content: Text('Code entered is $verificationCode'),
                      //             );
                      //           }
                      //       );
                      //     }, // end onSubmit
                      //   ),
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: FontName.poppinsMedium,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff254fd5),
                              elevation: 3,
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontStyle: FontStyle.normal),
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.all(5)),
                          onPressed:submit? () {
                            String? text = widget.otp.toString();
                            List<String>? result = text.split('');

                            print("result:${result}");

                            _otp = _fieldOne.text +
                                _fieldTwo.text +
                                _fieldThree.text +
                                _fieldFour.text +
                                _fieldFive.text +
                                _fieldSix.text;

                            print("_otp:${_otp}");
                            print("_otp:${widget.otp}");

                            if (_otp == widget.otp.toString()) {
                              print("OTP is verified");
                              _otpBloc.add(otpverifyevent(
                                  id: widget.userid, otp: widget.otp));
                              _otpBloc.add(otpsignin(email: widget.email, password: widget.password));

                              // _otpBloc.add(redirecttohomedashboard(
                              //     userid: widget.userid));
                            } else {
                              print("OTP is incorrect");
                            }
                          }:null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Didnt Receive the OTP?',
                              style: const TextStyle(
                                fontFamily: FontName.poppinsMedium,
                                fontSize: 14,
                                color: Color(0xffd8d8d8),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Resend',
                                    style: TextStyle(
                                      color: Color(0xff254fd5),
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 14,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                      })
                              ]),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;

  // final bool autoFocus;
  bool? first, last;

  OtpInput({required this.controller, this.first, this.last}) : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextField(
        autofocus: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Color(0xff254fd5),
        decoration: const InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xff254fd5), width: 1.0),
            ),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        // onChanged: (value) {
        //   if (value.isNotEmpty) {
        //     FocusScope.of(context).nextFocus();
        //   }
        // },
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length == 0 && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
