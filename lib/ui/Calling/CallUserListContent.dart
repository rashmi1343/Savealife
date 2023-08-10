import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:savealifedemoapp/Model/GetAllUsersResponse.dart';
import 'package:savealifedemoapp/bloc/Calling_bloc/calling_bloc.dart';
import 'package:savealifedemoapp/utils/pref.dart';

class CallUserListContent extends StatefulWidget {
  String accesstoken;

  CallingBloc callBloc;
  List<User> userslist;

  CallUserListContent(
      {required this.userslist,
      required this.accesstoken,
      required this.callBloc})
      : super();

  @override
  _CallUserListContentState createState() => _CallUserListContentState();
}

class _CallUserListContentState extends State<CallUserListContent> {
  late CallingBloc callBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callBloc = widget.callBloc;
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
                child: _createUserCallingList(widget.userslist))));
  }

  Widget _createUserCallingList(List<User> userModel) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListView.separated(
            itemBuilder: ((context, index) => InkWell(
                onTap: () {
                  //print("calling");

                 Prefs.setString("callinguserid", userModel[index].id.toString());
                 Prefs.setString("callingusername", userModel[index].username);
                  callBloc
                      .add(CallUserEvent(mobileno: userModel[index].mobile, senderuserid: userModel[index].id.toString(), senderusername: userModel[index].username));
                },
                child: _createUserCallItem(userModel[index]))),
            separatorBuilder: ((context, index) => const Divider()),
            itemCount: userModel.length));
  }

  Widget _createUserCallItem(User userData) {
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
              ),
              const Spacer(),
              const Icon(
                Icons.phone,
                color: Color(0xffc32c37),
                size: 25,
              ),
            ],
          )
        ],
      ),
    );
  }
}
