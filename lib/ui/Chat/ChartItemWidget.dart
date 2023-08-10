

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class ChatItemWidget extends StatefulWidget{
  var index;
  var messages;
  var msgsendtype;

  ChatItemWidget(this.index,this.messages, this.msgsendtype);




  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("message: "+widget.messages.toString());
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    // if msgsendtype ==1 then sender else receiver

       return
         widget.msgsendtype==1?
         Container(

          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: const EdgeInsets.only(right: 10.0),
                  child:  Text(
                   widget.messages ,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ], // aligns the chatitem to right end
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                    child: Text(
                      DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(1565888474278)),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.normal),
                    ),
                  )])
          ])) :
         Container(

             child: Column(children: <Widget>[
               Row(
                 mainAxisAlignment:
                 MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                     width: 200.0,
                     decoration: BoxDecoration(
                         color: Colors.blue,
                         borderRadius: BorderRadius.circular(8.0)),
                     margin: const EdgeInsets.only(right: 10.0),
                     child:  Text(
                       widget.messages ,
                       style: TextStyle(color: Colors.white),
                     ),
                   )
                 ], // aligns the chatitem to right end
               ),
               Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                       child: Text(
                         DateFormat('dd MMM kk:mm')
                             .format(DateTime.fromMillisecondsSinceEpoch(1565888474278)),
                         style: const TextStyle(
                             color:Colors.blue,
                             fontSize: 12.0,
                             fontStyle: FontStyle.normal),
                       ),
                     )])
             ]));

    // else {
    //   // This is a received message
    //   return Container(
    //     margin: const EdgeInsets.only(bottom: 10.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Row(
    //           children: <Widget>[
    //             Container(
    //               padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
    //               width: 200.0,
    //               decoration: BoxDecoration(
    //                   color: Colors.blue,
    //                   borderRadius: BorderRadius.circular(8.0)),
    //               margin: const EdgeInsets.only(left: 10.0),
    //               child: const Text(
    //                 'This is a received message',
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //             )
    //           ],
    //         ),
    //         Container(
    //           margin: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
    //           child: Text(
    //             DateFormat('dd MMM kk:mm')
    //                 .format(DateTime.fromMillisecondsSinceEpoch(1565888474278)),
    //             style: const TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 12.0,
    //                 fontStyle: FontStyle.normal),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // }
  }
}