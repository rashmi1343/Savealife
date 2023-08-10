import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:savealifedemoapp/Model/GetAllUsersResponse.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Repository/SaveALifeRepository.dart';

part 'calling_event.dart';
part 'calling_state.dart';

class CallingBloc extends Bloc<CallingEvent, CallingState> {

  SaveaLifeRepository saveaLifeRepository;
  String accesstoken;
  int id;

  CallingBloc( {required this.accesstoken,
    required this.saveaLifeRepository,
    required this.id}) : super(UserLoadingState()) {
    on<CallingEvent>((event, emit) async {
            if(event is FetchCallingUserEvent) {
              List<User>? userDataArr =
              (await saveaLifeRepository.getAllUsersApi(accesstoken, this.id))!;
      //  emit(loadedUserSuccessState(userDataArr: userDataArr, id: id));
      print("event called in user_bloc");
      emit(UserLoadingSucessState(userDataArr: userDataArr));
            }

            if(event is CallUserEvent) {
            /*  var url = Uri.parse("tel:"+event.mobileno);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }*/
              emit(CallUserState(mobileno: event.mobileno, senderuserid: event.senderuserid, senderusername: event.senderusername));
            }
    });
  }
}
