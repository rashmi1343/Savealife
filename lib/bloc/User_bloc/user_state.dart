import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:savealifedemoapp/Model/NotificationResponse.dart';

import '../../Model/GetAllUsersResponse.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserLoadingState extends UserState {
  @override
  List<Object?> get props => [];
}

class loadedUserSuccessState extends UserState {
  final List<User> userDataArr;

  // int?id;
  //loadedUserSuccessState({required this.userDataArr,required this.id});
  loadedUserSuccessState({required this.userDataArr});

  @override
  List<Object?> get props => [userDataArr];
}

class SendHelpRequestSucessState extends UserState {
  final String msg;
  const SendHelpRequestSucessState({required this.msg});

  List<Object?> get props =>[];
}
class SendHelpProgressState extends UserState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
class UserFailState extends UserState {
  final String failuremessage;

  UserFailState(this.failuremessage);

  @override
  List<Object> get props => [failuremessage];
}

class SendMessageNotificationState extends UserState {
  final String devtoken;
  final String message;

  const SendMessageNotificationState({required this.devtoken,required this.message});

  @override
  List<Object?> get props => [devtoken];
}

class SendMessageNotificationSuccessState extends UserState {
  final NotificationResponse notificationResponse;

  const SendMessageNotificationSuccessState(
      {required this.notificationResponse});

  @override
  List<Object> get props => [notificationResponse];
}
