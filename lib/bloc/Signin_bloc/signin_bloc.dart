import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../Model/LoginResponse.dart';
import '../../Repository/SaveALifeRepository.dart';

part 'signin_event.dart';

part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SaveaLifeRepository saveALiferepository;
  // String username;
  // String password;

  SigninBloc(
      {required this.saveALiferepository,
     })
      : super(SigninInitial()) {
    on<SigninEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        LoginResponse loginresponsedata =
            await saveALiferepository.signinApi(event.email, event.password);

        emit(signingettokenstate(lgresponse: loginresponsedata));
      }
      // if (event is redirecttohomedashboard) {
      //   emit(SigninredirectState());
      // }
    });
  }

  SigninInitial get initialState => SigninInitial();
}
