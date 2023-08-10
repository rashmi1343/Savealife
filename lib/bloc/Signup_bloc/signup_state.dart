part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();
}

class SignupInitial extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignupRegisterState extends SignupState {
 final String username;
 final String password;
 final String mobileno;
 final String email;

 const  SignupRegisterState({required this.username, required this.password, required this.mobileno,required this.email});

 @override
  List<Object?> get props => [username, password, mobileno,email];

}

class SignupSuccessState extends SignupState {
  final SignUpResponse signUpResponse;

  const SignupSuccessState({required this.signUpResponse});

  @override
  List<Object> get props => [signUpResponse];
}

class SignupFailureState extends SignupState {
  final String failuremessage;

  const SignupFailureState(this.failuremessage);

  @override
  List<Object> get props => [failuremessage];
}
class SignupValidationState extends SignupState {
  final SignUpErrors errormessage;
  //
  // const SignupValidationState(this.errormessage);
  const SignupValidationState({required this.errormessage});

  @override
  List<Object> get props => [errormessage];
}