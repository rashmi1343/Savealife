part of 'calling_bloc.dart';

@immutable
abstract class CallingEvent {}


class FetchCallingUserEvent extends CallingEvent {
  FetchCallingUserEvent();

  @override
  List<Object> get props => [];
}


class CallUserEvent extends CallingEvent {

  String mobileno;
  String senderuserid;
  String senderusername;
  CallUserEvent({required this.mobileno, required this.senderuserid, required this.senderusername});

  @override
  List<Object> get props => [mobileno, senderuserid, senderusername];
  
}


