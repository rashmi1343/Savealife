import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';

import '../../Model/GetAllMenuResponse.dart';

part 'homedashboard_event.dart';

part 'homedashboard_state.dart';

class homedashboardbloc extends Bloc<homeDashboardEvent, homedashboardstate> {
  SaveaLifeRepository saveaLifeRepository;
  String accesstoken;
  List<Menu> menu = [];

  homedashboardbloc(
      {required this.saveaLifeRepository, required this.accesstoken})
      : super(loadinghomedashboardstate()) {
    on<homeDashboardEvent>((event, emit) async {
      if (event is loadinghomedashboard) {
        emit(loadinghomedashboardstate());
      }

      if (event is loadedhomedashboard) {
        menu = (await saveaLifeRepository.salHomeApi(accesstoken))!;
        emit(loadedhomedashboardstate(menu: menu));
      }

      if(event is clickhomedashboarditemevent) {
        emit(clickhomedashboarditemstate(menuid: event.menuid));

      }

    });
  }
}
