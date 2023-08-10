part of 'send_help_bloc.dart';

abstract class SendHelpBlocEvent extends Equatable {
  const SendHelpBlocEvent();

  @override
  List<Object> get props => [];
}

class SendHelpInitialEvent extends SendHelpBlocEvent {}

class SendHelpProgressEvent extends SendHelpBlocEvent {}

class SendHelpRequestEvent extends SendHelpBlocEvent {
  SendHelpRequestModel sendHelpRequestModel;
  SendHelpRequestEvent({required this.sendHelpRequestModel});
}
