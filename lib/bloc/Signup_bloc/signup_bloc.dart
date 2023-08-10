import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../Model/SignUpErrorResponse.dart';
import '../../Model/SignUpResponse.dart';
import '../../Repository/SaveALifeRepository.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SaveaLifeRepository saveALiferepository;

  SignupBloc({required this.saveALiferepository}) : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      /*if(event is SignupResponseevent) {
        emit(SignupSuccessState(signUpResponse: signUpResponseData));
      }*/

      if (event is SignUpButtonPressed) {
        // sending request to server state (in -Process state)
        emit(SignupRegisterState(
            username: event.username,
            password: event.password,
            mobileno: event.mobileNumber,
            email: event.email,
       ));

        SignUpResponse signUpResponseData = await saveALiferepository.signupApi(
            event.username, event.email, event.mobileNumber, event.password,event.deviceID);
        // await saveALiferepository.signupApi(
        //     event.username, event.email, event.mobileNumber);
        // response received from server state (successresponse state)
        emit(SignupSuccessState(signUpResponse: signUpResponseData));
      }
    });
  }

  @override
  SignupInitial get initialState => SignupInitial();
}
