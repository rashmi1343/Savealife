part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();
}

// otp load state
class otpinitialState extends OtpState {
  @override
  List<Object?> get props => [];
}

// otp validation state
class otpvalidationState extends OtpState {
  @override
  List<Object?> get props => [];
}

// otp verify failure state
class otpverifyfailurestate extends OtpState {
  @override
  List<Object?> get props => [];
}

class otpgettokenstate extends OtpState {
  final LoginResponse lgresponse;

  otpgettokenstate({required this.lgresponse});

  @override
  List<Object?> get props => [];
}
class otpVerifyState extends OtpState {
  final VerifyOtpResponse verifyOtpResponse;

  otpVerifyState({required this.verifyOtpResponse});

  @override
  List<Object?> get props => [];
}

