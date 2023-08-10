part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

// get Profile state
class ProfileloadingState extends ProfileState {
  final int userid;

  ProfileloadingState({required this.userid});

  @override
  List<Object> get props => [userid];
}

class ProfileloadedState extends ProfileState {
  final GetUserProfile userprofiledata;

  // List<Country> countrieslist=[];

  ProfileloadedState({required this.userprofiledata});

  // ProfileloadedState({required this.userprofiledata,required this.countrieslist});

  @override
  List<Object> get props => [userprofiledata];
}

// Profile loading failure state
class ProfilefailureState extends ProfileState {
  late final message;

  ProfilefailureState({required message});

  @override
  List<Object> get props => [message];
}

class ProfileSubmitState extends ProfileState {
  late final UpdateuserProfileRequest userprofiledata;

  ProfileSubmitState({required userprofiledata});

  @override
  List<Object> get props => [userprofiledata];
}

class ProfileUpdateSuccessState extends ProfileState {
  final UpdateProfileResponse updateprofileresponse;

  ProfileUpdateSuccessState({required this.updateprofileresponse});
}

// class GetCountryDropdownState extends ProfileState {
//   @override
//   List<Object> get props => [];
// }
//
// class LoadCountryDropdownState extends ProfileState {
//   List<Country> countrieslist = [];
//
// //Country? countrieslist;
//
//   LoadCountryDropdownState({required this.countrieslist});
//
//   @override
//   List<Object> get props => [countrieslist!];
// }
//
// class GetStatesDropdownState extends ProfileState {
//   String countrycode;
//
//   GetStatesDropdownState({required this.countrycode});
//
//   @override
//   List<Object> get props => [countrycode];
// }
//
// class LoadStatesDropdownState extends ProfileState {
//   StatesResponse statesResponse;
//
//   LoadStatesDropdownState({required this.statesResponse});
//
//   @override
//   List<Object> get props => [statesResponse];
// }
