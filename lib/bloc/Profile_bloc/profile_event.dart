part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class getIntialProfileevent extends ProfileEvent {
  // late final int userid;

  // getProfileevent({required userid});

  // @override
  // List<Object> get props => [userid];
}

class ProfileLoadingEvent extends ProfileEvent {}

class ProfilLoadedEvent extends ProfileEvent {
  final GetUserProfile userprofiledata;

  ProfilLoadedEvent({required this.userprofiledata});
}

class getProfileevent extends ProfileEvent {
  late final int userid;

  getProfileevent({required userid});

  @override
  List<Object> get props => [userid];
}

class updateProfileEvent extends ProfileEvent {
  final UpdateuserProfileRequest userprofilerequest;

  updateProfileEvent({required this.userprofilerequest});

  @override
  List<Object> get props => [userprofilerequest];
}

// class GetCountryDropdownEvent extends ProfileEvent {
//   @override
//   List<Object> get props => [];
// }
//
// class LoadCountryDropdownEvent extends ProfileEvent {
//   List<Country> selectedCountry;
//
//   //Country selectedCountry;
//
//   LoadCountryDropdownEvent({required this.selectedCountry});
//
//   @override
//   List<Object> get props => [selectedCountry];
// }
//
// class GetstatesDropdownEvent extends ProfileEvent {
//   String countrycode;
//
//   GetstatesDropdownEvent({required this.countrycode});
//
//   @override
//   List<Object> get props => [countrycode];
// }
//
// class LoadstatesDropdownEvent extends ProfileEvent {
//   StatesResponse statesResponse;
//
//   LoadstatesDropdownEvent({required this.statesResponse});
//
//   @override
//   List<Object> get props => [statesResponse];
// }

class ProfileUpdateSuccessEvent extends ProfileEvent {
  final UpdateProfileResponse updateprofileresponse;

  ProfileUpdateSuccessEvent({required this.updateprofileresponse});
}
