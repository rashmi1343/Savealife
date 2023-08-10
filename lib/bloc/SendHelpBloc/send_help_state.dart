part of 'send_help_bloc.dart';

abstract class SendHelpBlocState extends Equatable {
  const SendHelpBlocState();

  @override
  List<Object> get props => [];
}

class SendHelpInitialState extends SendHelpBlocState {}

class SendHelpProgressState extends SendHelpBlocState {}

class SendHelpRequestState extends SendHelpBlocState {}

class SendHelpRequestSucessState extends SendHelpBlocState {
  final String msg;
  const SendHelpRequestSucessState({required this.msg});
}
