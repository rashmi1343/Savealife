import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../Model/GetAllUsersResponse.dart';
import '../../Repository/SaveaLifeRepository.dart';
import '../../bloc/User_bloc/user_bloc.dart';
import '../../bloc/User_bloc/user_event.dart';
import '../../bloc/User_bloc/user_state.dart';
import 'ChatScreen.dart';

class ChatAllUsers extends StatefulWidget {
  String accesstoken;

  UserBloc userBloc;
  List<User> userslist;

  ChatAllUsers(
      {required this.userslist,
      required this.accesstoken,
      required this.userBloc})
      : super();

  @override
  State<ChatAllUsers> createState() => _ChatAllUsersState();
}

class _ChatAllUsersState extends State<ChatAllUsers> {
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();

    userBloc = widget.userBloc;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 75,
        // height: 702,
        child: Card(
            elevation: 0,
            margin: const EdgeInsets.all(2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                // child: _createUserList(widget.userslist))));
                child: ListView.separated(
                    itemBuilder: ((context, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  userBloc: widget.userBloc,
                                  selectedUser: widget.userslist[index])));
                        },
                        child: _createUserItem(widget.userslist[index]))),
                    separatorBuilder: ((context, index) => const Divider()),
                    itemCount: widget.userslist.length))));
  }
}

Widget _createUserItem(User userData) {
  return Container(
    height: 70,
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xff764abc),
              child: Text(userData.username?[0] ?? ""),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userData.username ?? "",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff111111),
                      fontFamily: 'GraphikMedium'),
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}
