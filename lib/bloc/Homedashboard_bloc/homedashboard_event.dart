part of 'homedashboard_bloc.dart';

@immutable
abstract class homeDashboardEvent {
  @override
  List<Object> get props => [];
}


class loadinghomedashboard extends homeDashboardEvent {

  @override
  List<Object> get props => [];
}



class loadedhomedashboard extends homeDashboardEvent {

  @override
  List<Object> get props => [];
}

class clickhomedashboarditemevent extends homeDashboardEvent {

  int menuid;
  clickhomedashboarditemevent({required this.menuid});
  @override
  List<Object> get props => [];
}


