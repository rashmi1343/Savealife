import 'package:flutter/cupertino.dart';

import '../../Model/Help/SendHelpRequestModel.dart';


@immutable
abstract class UserEvent {
  @override
  List<Object> get props => [];
}

class FetchUserEvent extends UserEvent {
  FetchUserEvent();

  @override
  List<Object> get props => [];
}

class SendMessageNotificationEvent extends UserEvent {
  //final NotificationResponse notificationResponse;
  final String devtoken;
  final String textMessage;

  SendMessageNotificationEvent(
      {required this.devtoken, required this.textMessage});

  @override
  List<Object> get props => [];
}
class SendHelpRequestEvent extends UserEvent {
  SendHelpRequestModel sendHelpRequestModel;
  SendHelpRequestEvent({required this.sendHelpRequestModel});
}
class SendHelpProgressEvent extends UserEvent {}