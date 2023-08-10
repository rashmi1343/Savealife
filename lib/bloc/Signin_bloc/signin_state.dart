part of 'signin_bloc.dart';

@immutable
abstract class SigninState extends Equatable {
  const SigninState();
}

class SigninInitial extends SigninState {
  @override
  List<Object?> get props => [];
}

class signingettokenstate extends SigninState {
  final LoginResponse lgresponse;

  signingettokenstate({required this.lgresponse});

  @override
  List<Object?> get props => [];
}

class SigninfailureState extends SigninState {
  final String failuremessage;

  const SigninfailureState(this.failuremessage);

  @override
  List<Object> get props => [failuremessage];
}

// Signin verify redirect state
class SigninredirectState extends SigninState {
  @override
  List<Object?> get props => [];
}
