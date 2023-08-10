part of 'signin_bloc.dart';

@immutable

abstract class SigninEvent extends Equatable {
  SigninEvent();
}


class LoginButtonPressed extends SigninEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LoginButtonPressed { email: $email, password: $password }';

}
class redirecttohomedashboard extends SigninEvent {
 // late final int userid;

  redirecttohomedashboard();

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}