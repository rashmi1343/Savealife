part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {
  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends SignupEvent {
  final String username;
  final String email;
  final String mobileNumber;
  final String password;
  final String deviceID;

  SignUpButtonPressed(
      {required this.username,
      required this.email,
      required this.mobileNumber,
      required this.password,
      required this.deviceID});

  @override
  List<Object> get props => [username, email, mobileNumber, password];

  @override
  String toString() =>
      'SignUpButtonPressed { username: $username, email: $email,mobileNumber: $mobileNumber,password: $password }';
}

class SignupResponseevent extends SignupEvent {
  @override
  List<Object> get props => [];
}
