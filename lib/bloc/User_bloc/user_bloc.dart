import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../Model/GetAllUsersResponse.dart';
import '../../Model/NotificationResponse.dart';
import '../../Repository/SaveALifeRepository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  SaveaLifeRepository saveaLifeRepository;
  String accesstoken;
  int id;

  UserBloc(
      {required this.accesstoken,
      required this.saveaLifeRepository,
      required this.id})
      : super(UserLoadingState()) {
    on<UserEvent>((event, emit) async {
      // emit(UserLoadingState());

      // if (event is UserLoadingState) {
      //   emit(UserLoadingState());
      // }

      if (event is FetchUserEvent) {
        List<User>? userDataArr =
            (await saveaLifeRepository.getAllUsersApi(accesstoken, this.id))!;
        //  emit(loadedUserSuccessState(userDataArr: userDataArr, id: id));
        print("event called in user_bloc");
        emit(loadedUserSuccessState(userDataArr: userDataArr));
      }
      if (event is SendHelpRequestEvent) {
        // emit(SendHelpProgressState());
        try {
          final response = await saveaLifeRepository.sendHelpRequest(
              event.sendHelpRequestModel, accesstoken);
          emit(SendHelpRequestSucessState(msg: response));
        } catch (e) {
          print(e.toString());
        }
      }
      if (event is SendMessageNotificationEvent) {
        NotificationResponse notificationResponse = await saveaLifeRepository
            .messagenotificationApi(event.devtoken, event.textMessage);
        emit(SendMessageNotificationSuccessState(notificationResponse: notificationResponse));
      }
    });
  }

/* @override
  UserLoadingState get initialState => UserLoadingState(); */
}
