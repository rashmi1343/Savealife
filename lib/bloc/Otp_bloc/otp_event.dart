part of 'otp_bloc.dart';




@immutable
abstract class OtpEvent {
  @override
  List<Object> get props => [];
}

class otpsignin extends OtpEvent {
    //final String username;
    final String email;
    final String password;
    otpsignin({required this.email, required this.password});
}
class otpverifyevent extends OtpEvent {

  final int id;
  final int otp;
  otpverifyevent({required this.id, required this.otp});
}
