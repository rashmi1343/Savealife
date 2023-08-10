part of 'gethelpmenu_bloc.dart';


@immutable
abstract class GethelpMenuEvent {
  @override
  List<Object> get props => [];
}


class loadingGethelpmenu extends GethelpMenuEvent {

  @override
  List<Object> get props => [];
}
class NavigateToHomeEvent extends GethelpMenuEvent{
  @override
  List<Object> get props => [];
}


class loadedGethelpmenu extends GethelpMenuEvent {

  @override
  List<Object> get props => [];
}


class clickGetHelpmenuevent extends GethelpMenuEvent{
  int? id;
  clickGetHelpmenuevent({required this.id});

  @override
  List<Object> get props => [];
}