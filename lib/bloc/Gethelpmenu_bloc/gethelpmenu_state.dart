part of 'gethelpmenu_bloc.dart';

@immutable

abstract class GethelpMenuState extends Equatable {
  const GethelpMenuState();
}


class LoadingGetHelpMenuState extends GethelpMenuState {

  @override
  List<Object?> get props =>[];
}


class LoadedGetHelpMenustate extends GethelpMenuState {

  List<Gethelp> gethelpmenu;

  LoadedGetHelpMenustate({required this.gethelpmenu});

  @override
  List<Object?> get props =>[gethelpmenu];

}


class ClickGetHelpMenuState extends GethelpMenuState{

  int? gethelpmenuId;
  ClickGetHelpMenuState({required this.gethelpmenuId});


  List<Object?> get props => [gethelpmenuId];

}
class NavigateToHomeState extends GethelpMenuState{
  @override
  List<Object> get props => [];
}

class FailureGetHelpMenuState extends GethelpMenuState {
  final String failuremessage;
  FailureGetHelpMenuState(this.failuremessage);

  @override
  List<Object> get props => [failuremessage];
}