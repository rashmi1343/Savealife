import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../Model/CountriesResponse.dart';
import '../../Model/Getuserprofile.dart';
import '../../Model/StatesResponse.dart';
import '../../Model/UpdateProfileResponse.dart';
import '../../Model/UpdateuserProfileRequest.dart';
import '../../Repository/SaveaLifeRepository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late GetUserProfile userprofilerequest;
  late UpdateuserProfileRequest updateprofilerequest;
  late SaveaLifeRepository savealifeRepository;

  late UpdateProfileResponse msgupdatedprofile;
  String accesstoken;
  int userid;

  // String countrycode;
 // List<Country> country = [];

//Country? country ;
  ProfileBloc({
    required this.accesstoken,
    required savealifeRepository,
    required this.userid,
  }) : super(ProfileInitialState()) {
    on<ProfileEvent>((event, emit) async {
      if (event is getIntialProfileevent) {
        print('getIntialProfileevent called');
        emit(ProfileloadingState(userid: userid));
      }
      if (event is ProfileLoadingEvent) {
        print('ProfileLoadingEvent called');
        emit(ProfileloadingState(userid: userid));
      }
      // if (event is GetCountryDropdownEvent) {
      //   country = (await savealifeRepository.getCountriesApi(accesstoken))!;
      //   emit(LoadCountryDropdownState(countrieslist: country));
      // }
      //
      // if (event is GetstatesDropdownEvent) {
      //   StatesResponse statesresponse = (await savealifeRepository.getStatesApi(
      //       accesstoken, event.countrycode))!;
      //   emit(LoadStatesDropdownState(statesResponse: statesresponse));
      //   emit(ProfileloadedState(userprofiledata: userprofilerequest, countrieslist:country));
      //
      // }
      if (event is getProfileevent) {
        userprofilerequest =
        await savealifeRepository.getUserProfileApi(accesstoken, userid);
        emit(ProfileloadedState(
            userprofiledata: userprofilerequest));
      } else if (event is updateProfileEvent) {
        msgupdatedprofile = await savealifeRepository.UpdateProfileApi(
            accesstoken, event.userprofilerequest);
        emit(ProfileUpdateSuccessState(
            updateprofileresponse: msgupdatedprofile));
      }
      // if (event is getProfileevent) {
      //   userprofilerequest =
      //       await savealifeRepository.getUserProfileApi(accesstoken, userid);
      //   emit(ProfileloadedState(
      //       userprofiledata: userprofilerequest, countrieslist: country));
      // } else if (event is updateProfileEvent) {
      //   msgupdatedprofile = await savealifeRepository.UpdateProfileApi(
      //       accesstoken, event.userprofilerequest);
      //   emit(ProfileUpdateSuccessState(
      //       updateprofileresponse: msgupdatedprofile));
      // }
    });
  }


}
