import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../Model/GetAllUsersResponse.dart';
import '../../Repository/SaveaLifeRepository.dart';
import '../../bloc/User_bloc/user_bloc.dart';
import '../../bloc/User_bloc/user_event.dart';
import '../../bloc/User_bloc/user_state.dart';

class MemberContent extends StatefulWidget {
  String accesstoken;

  UserBloc userBloc;
  List<User> userslist;

  MemberContent(
      {required this.userslist,
      required this.accesstoken,
      required this.userBloc})
      : super();

  @override
  State<MemberContent> createState() => _MemberContentState();
}

class _MemberContentState extends State<MemberContent> {
 // List<User> get totaluserslist => widget.userslist;

  // List<User>  totalusers=[];
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    // userBloc = BlocProvider.of<UserBloc>(context);
    // totalusers=widget.userslist;
  //  print("users length ${totaluserslist.length}");
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
                child: _createUserList(widget.userslist))));
  }

  Widget _buildGetHelpMenuView(List<User> totaluserslist) {
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
                child: ListView.separated(
                    itemBuilder: ((context, index) =>
                        createUserItem(totaluserslist[index])),
                    separatorBuilder: ((context, index) => const Divider()),
                    itemCount: totaluserslist.length))));
  }

  createUserItem(User totaluser) {
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
                child: Text(totaluser.username?[0] ?? ""),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    totaluser.username ?? "",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff111111),
                        fontFamily: 'GraphikMedium'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    totaluser.mobile ?? "",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff111111),
                        fontFamily: 'GraphikMedium'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    totaluser.email ?? "",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                        fontFamily: 'GraphikMedium'),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildLoadingUI() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget _buildErrorUi(String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    ),
  );
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
                const SizedBox(
                  height: 5,
                ),
                Text(
                  userData.mobile ?? "",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff111111),
                      fontFamily: 'GraphikMedium'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  userData.email ?? "",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                      fontFamily: 'GraphikMedium'),
                )
              ],
            )
          ],
        )
      ],
    ),
  );
}

Widget _createUserList(List<User> userModel) {
  return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.separated(
          itemBuilder: ((context, index) => _createUserItem(userModel[index])),
          separatorBuilder: ((context, index) => const Divider()),
          itemCount: userModel.length));
}
