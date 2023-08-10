import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../Model/GetAllUsersResponse.dart';
import '../../bloc/User_bloc/user_bloc.dart';
import '../../bloc/User_bloc/user_event.dart';
import '../../utils/Constant.dart';
import 'ChartItemWidget.dart';

class ChatScreen extends StatefulWidget {
  UserBloc userBloc;
  User selectedUser;

  ChatScreen({required this.selectedUser, required this.userBloc}) : super();

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  late UserBloc userBloc;
  static final List<String> messages = [];
  bool sendButton = false;
  bool show = false;
  FocusNode focusNode = FocusNode();
  int msgsend = 0;
  String _title = 'Chat';
  @override
  void initState() {
    super.initState();

    print("username:${widget.selectedUser.name}");
    print("token:${widget.selectedUser.devtoken}");

    userBloc = widget.userBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff9fdfe),
        appBar: AppBar(
          toolbarHeight: 75,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.light, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          backgroundColor: const Color(0xfff9fdfe),
          elevation: 0,
          centerTitle: false,
          title: AppBarTitle(widget.selectedUser.username),
          leading: Builder(
            builder: (context) => Container(
              margin: const EdgeInsets.only(left: 10),
              child: IconButton(
                alignment: Alignment.centerLeft,
                icon: Image.asset(
                  "assets/images/back.png",
                  color: const Color(0xff000000),
                  height: 21,
                  width: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                  child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    ChatItemWidget(index, textEditingController.text, msgsend),
                itemCount: messages.length,
                reverse: false,
                controller: listScrollController,
              )), //Chat list
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: const BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                    color: Colors.white),
                child: Row(
                  children: <Widget>[
                    Material(
                      color: Colors.white,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: IconButton(
                          icon: const Icon(Icons.face),
                          color: Colors.grey,
                          onPressed: () {},
                        ),
                      ),
                    ),

                    // Text input
                    Flexible(
                      child: Container(
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0),
                          controller: textEditingController,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                    // Send Message Button
                    Material(
                      color: Colors.white,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () => {
                            userBloc.add(SendMessageNotificationEvent(
                                devtoken: widget.selectedUser.devtoken,
                                textMessage: textEditingController.text)),
                            setState(() {
                              messages.add(textEditingController.text);
                              if (textEditingController.text.length > 0) {
                                msgsend = 1;
                                // for msg send
                              } else {
                                msgsend = 0;
                              }
                              textEditingController.text='';
                            }),
                          },
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ) // The input widget
            ],
          ),
        ]));
  }
}
