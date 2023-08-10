part of 'homedashboard_bloc.dart';




abstract class homedashboardstate extends Equatable {
  const homedashboardstate();
}


class loadinghomedashboardstate extends homedashboardstate {

  @override
  List<Object?> get props =>[];
}


class loadedhomedashboardstate extends homedashboardstate {

  List<Menu> menu;

  loadedhomedashboardstate({required this.menu});

  @override
  List<Object?> get props =>[menu];

}


class failurehomedashboardstate extends homedashboardstate {
  final String failuremessage;
   failurehomedashboardstate(this.failuremessage);

  @override
  List<Object> get props => [failuremessage];
}

class clickhomedashboarditemstate extends homedashboardstate {
  int menuid;
  clickhomedashboarditemstate({required this.menuid});

  @override
  List<Object?> get props => [menuid];

}