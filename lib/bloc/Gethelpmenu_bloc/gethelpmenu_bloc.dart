import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../Model/GetHelpMenuResponse.dart';
import '../../Repository/SaveALifeRepository.dart';

part 'gethelpmenu_event.dart';

part 'gethelpmenu_state.dart';

class GethelpMenuBloc extends Bloc<GethelpMenuEvent, GethelpMenuState> {

  SaveaLifeRepository saveaLifeRepository;
  String accesstoken;
  List<Gethelp> gethelpmenu = [];

  GethelpMenuBloc(
      {required this.saveaLifeRepository, required this.accesstoken})
      : super(LoadingGetHelpMenuState()) {
    on<GethelpMenuEvent>((event, emit) async {
      if (event is loadingGethelpmenu) {
        emit(LoadingGetHelpMenuState());
      }
    if(event is NavigateToHomeEvent){
      emit(NavigateToHomeState());
    }

      if (event is loadedGethelpmenu) {
        gethelpmenu = (await saveaLifeRepository.getHelpApi(accesstoken))!;
        emit(LoadedGetHelpMenustate(gethelpmenu: gethelpmenu));
      }
      if (event is clickGetHelpmenuevent) {
        emit(ClickGetHelpMenuState(gethelpmenuId: event.id));
      }
    });
  }
}
