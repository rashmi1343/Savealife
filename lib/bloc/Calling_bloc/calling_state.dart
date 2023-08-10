part of 'calling_bloc.dart';



abstract class CallingState extends Equatable {

  const CallingState();

}


class UserLoadingState extends CallingState {
  @override
  List<Object?> get props => [];
}


class UserLoadingSucessState extends CallingState {

  final List<User> userDataArr;
  UserLoadingSucessState({required this.userDataArr});

  @override
  List<Object?> get props => [userDataArr];
}


class CallUserState extends CallingState {


  String mobileno;
  String senderuserid;
  String senderusername;
  CallUserState({required this.mobileno, required this.senderuserid, required this.senderusername});

  @override
  List<Object?> get props => [mobileno, senderuserid, senderusername];

}

