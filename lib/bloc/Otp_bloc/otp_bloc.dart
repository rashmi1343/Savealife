import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:savealifedemoapp/Model/LoginResponse.dart';
import 'package:savealifedemoapp/Model/VerifyOTPResponse.dart';

import '../../Repository/SaveALifeRepository.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  SaveaLifeRepository savealiferepo;

  //String username;
  String email;
 String password;
  int id;
  int otp;

  // late String token;
  //late int userid;
  late LoginResponse authresponse;
  late VerifyOtpResponse verifyOtpResponse;

  OtpBloc({required this.savealiferepo,
     required this.email,
     required this.password,
    required this.id,
    required this.otp})
      : super(otpinitialState()) {
    on<OtpEvent>((event, emit) async {
      if (event is otpsignin) {
        authresponse =
            await savealiferepo.signinApi(this.email, this.password);
        emit(otpgettokenstate(lgresponse: authresponse));
      }
      if (event is otpverifyevent) {
        verifyOtpResponse =
        await savealiferepo.verifyOtp(this.id, this.otp);
        emit(otpVerifyState(verifyOtpResponse: verifyOtpResponse));
      }

    });
  }

  @override
  otpinitialState get initialState => otpinitialState();
}
