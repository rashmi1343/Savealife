import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Model/Help/AcceptHelpRequestResponse.dart';
import '../../Model/Help/HelpAcceptedResponse.dart';
import '../../Repository/SaveaLifeRepository.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../Userlocation/ReceiverMapViewRoute.dart';

class HelpRequest extends StatefulWidget {
  _HelpRequestState createState() => _HelpRequestState();
}

class _HelpRequestState extends State<HelpRequest> {
  late Userhelprequest userhelprequest;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  HelpAcceptedResponse? helpAcceptedResponse;
  int helpaccepted = 0;
  bool isDisabled = true;
  bool isApplyVisible = true;
  bool _accepthasBeenPressed = true;
  bool _declinehasBeenPressed = true;
  late Future<List<Userhelprequest>?> listhelprequest;
  List<Userhelprequest> arrelprequest = [];

  @override
  void initState() {
    print("init called");

    // _getAcceptHelpData();
    super.initState();
  }

  bool isTapped = false;

  /*Future<List<Userhelprequest>?> _getAcceptHelpData() async {

    listhelprequest=   SaveaLifeRepository().gethelprequestbyrecevierdeviceid();


    return listhelprequest;
  }*/

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
        title: AppBarTitle('Help Request'),
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
      body: FutureBuilder<List<Userhelprequest>?>(
        future: SaveaLifeRepository().gethelprequestbyrecevierdeviceid(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Text(
                      snapshot.data![index].id.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: FontName.poppinsMedium,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data![index].sendername.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: FontName.poppinsRegular,
                            )),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(snapshot.data![index].sendermobile.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: FontName.poppinsRegular,
                            )),
                      ],
                    ),
                    trailing: snapshot.data![index].ishelpaccepted == 1
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 30,
                                width: 100,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.blueGrey;
                                          return Colors.blueGrey;
                                        },
                                      ),
                                      //  elevation: 3,
                                      // textStyle: const TextStyle(
                                      //     color: Colors.white,
                                      //     fontSize: 10,
                                      //     fontStyle: FontStyle.normal),
                                      // shape: RoundedRectangleBorder(
                                      //     //to set border radius to button
                                      //     borderRadius:
                                      //         BorderRadius.circular(10)),
                                      // padding: const EdgeInsets.all(5)
                                    ),
                                    onPressed: () async {},
                                    child: const Text(
                                      "Accepted",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontName.poppinsRegular,
                                      ),
                                    )),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 85,
                                height: 30,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      // backgroundColor: _accepthasBeenPressed
                                      //     ? Colors.green
                                      //     : Colors.grey,
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.blueGrey;
                                          return Colors.green;
                                        },
                                      ),
                                    ),
                                    // elevation: 3,
                                    // textStyle: const TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 10,
                                    //     fontStyle: FontStyle.normal),
                                    // shape: RoundedRectangleBorder(
                                    //     //to set border radius to button
                                    //     borderRadius:
                                    //         BorderRadius.circular(10)),
                                    // padding: const EdgeInsets.all(5)),
                                    onPressed: () async {
                                      print("Clicked Once");
                                      print("api call with accept flag" + "1");

                                      helpaccepted = 1;
                                      print("helpaccepted: $helpaccepted");
                                      helpAcceptedResponse =
                                          await SaveaLifeRepository()
                                              .helpAcceptedApi(
                                                  helpaccepted,
                                                  snapshot.data![index].id,
                                                  "Help Request Accepted",
                                                  Prefs.getString("username")
                                                      .toString(),
                                                  Prefs.getString("email")
                                                      .toString(),
                                                  Prefs.getString("mobile")
                                                      .toString());
                                      Fluttertoast.showToast(
                                          msg: helpAcceptedResponse!.message,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1,
                                          backgroundColor: Color(0xff254fd5),
                                          textColor: Colors.white);
                                      Prefs.setInt("helprequestid",
                                          snapshot.data![index].id);
                                      setState(() {
                                        _accepthasBeenPressed =
                                            !_accepthasBeenPressed;
                                      });

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReceiverMapViewRoute(
                                                      accesstoken:
                                                          Prefs.getString(
                                                                  "accesstoken")
                                                              .toString())),
                                          (Route<dynamic> route) => false);

                                      // Navigator.push(
                                      //     navigatorKey.currentState!.context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ReceiverMapViewRoute(
                                      //                 accesstoken:
                                      //                     Prefs.getString(
                                      //                             "accesstoken")
                                      //                         .toString())));
                                      //accepted
                                    },
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontName.poppinsRegular,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 85,
                                height: 30,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.blueGrey;
                                          return Colors.red;
                                        },
                                      ),
                                    ),

                                    // elevation: 3,
                                    // textStyle: const TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 10,
                                    //     fontStyle: FontStyle.normal),
                                    // shape: RoundedRectangleBorder(
                                    //   //to set border radius to button
                                    //     borderRadius:
                                    //     BorderRadius.circular(10)),
                                    // padding: const EdgeInsets.all(5)),
                                    onPressed: () async {
                                      isDisabled = true;
                                      print("api call with decline flag" + "0");
                                      helpaccepted = 0;
                                      print("helpaccepted : $helpaccepted");

                                      helpAcceptedResponse =
                                          await SaveaLifeRepository()
                                              .helpAcceptedApi(
                                                  helpaccepted,
                                                  snapshot.data![index].id,
                                                  "Help Request Declined",
                                                  Prefs.getString("username")
                                                      .toString(),
                                                  Prefs.getString("email")
                                                      .toString(),
                                                  Prefs.getString("mobile")
                                                      .toString());
                                      Fluttertoast.showToast(
                                          msg: helpAcceptedResponse!.message,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white);

                                      setState(() {
                                        //   // _declinehasBeenPressed =
                                        //   //     !_declinehasBeenPressed;
                                        //  isDisabled = null;
                                        //
                                      });
                                    },
                                    child: const Text(
                                      "Decline",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontName.poppinsRegular,
                                      ),
                                    )),
                              )
                            ],
                          )
                    //  subtitle: Text(snapshot.data![index].date.toString()),
                    );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xff254fd5),
          ));
        },
      ),
    );
  }
}
