import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savealifedemoapp/Model/GetHelpMenuResponse.dart';

import '../../Model/GetAllMenuResponse.dart';
import '../../Repository/SaveALifeRepository.dart';
import '../../bloc/Gethelpmenu_bloc/gethelpmenu_bloc.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../AboutUsPage.dart';
import '../GetHelpFrom/GetHelpContent.dart';
import '../GetHelpFrom/GetHelpMenuPage.dart';
import '../HomeDashboard/homedashboard.dart';
import '../NavigationBar/layout.dart';
import '../SettingPage.dart';
import '../Signin/SigninPage.dart';

class GetHelpContent extends StatefulWidget {
  List<Gethelp> gethelpmenucontent;
  GethelpMenuBloc gethelpfromBloc;
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  int userid;
  GetHelpContent(
      {required this.gethelpmenucontent,
      required this.gethelpfromBloc,
      required this.savealiferep,
      required this.accesstoken,
      required this.userid})
      : super();

  @override
  _GetHelpContentState createState() => new _GetHelpContentState();
}

class _GetHelpContentState extends State<GetHelpContent>
    with TickerProviderStateMixin {
  String _lastSelected = 'TAB:0';

  List<Gethelp> get _gethelpmenu => widget.gethelpmenucontent;
  late GethelpMenuBloc _gethelpfromBloc;

  @override
  void initState() {
    print("_gethelpmenu length " + _gethelpmenu.length.toString());

    _gethelpfromBloc = widget.gethelpfromBloc;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenSize = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    //  return _buildGetHelpMenuView(_gethelpmenu);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Color(0xfff9fdfe),
          appBar: AppBar(
            toolbarHeight: 75,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xfff9fdfe),
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Color(0xfff9fdfe),
            elevation: 0,
            centerTitle: false,
            title: Transform(
              // you can forcefully translate values left side using Transform
              transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
              child: const Text(
                'Get Help From',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: FontName.poppinsSemiBold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff243444),
                ),
              ),
            ),
            leading: Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.only(left: 5),
                child: IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Image.asset(
                    "assets/images/back.png",
                    color: const Color(0xff000000),
                    height: 21,
                    width: 24,
                  ),
                  onPressed: () {
                    ApiData.gridclickcount = 0;
                    //  Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => homedashboard(
                              savealiferep: widget.savealiferep,
                              accesstoken: widget.accesstoken,
                              id: Prefs.getInt("userid")!,
                            )));
                  },
                ),
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child:
                        // Text(
                        //   _lastSelected,
                        //   style: TextStyle(fontSize: 32.0),
                        // ),
                        LayoutBuilder(builder: (context, constraints) {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        //const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _gethelpmenu.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing:
                              Platform.isIOS ? 10 : 15, // Chages HERE
                          mainAxisSpacing:
                              Platform.isIOS ? 10 : 15, // Chages HERE
                          childAspectRatio: 2,

                          mainAxisExtent: Platform.isIOS
                              ? DeviceUtil.isPad
                                  ? 200
                                  : 150
                              : 150,
                          //150,

                          crossAxisCount: Platform.isIOS
                              ? DeviceUtil.isPad
                                  ? 6
                                  : 3
                              : 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              child: _cellItem(
                                  context, _gethelpmenu[index], index),
                              onTap: () {
                                if (ApiData.gridclickcount == 0) {
                                  ApiData.gridclickcount =
                                      ApiData.gridclickcount + 1;
                                  print(
                                      "gridclickcount:${ApiData.gridclickcount}");

                                  _gethelpfromBloc
                                      .add(clickGetHelpmenuevent(id: index));
                                }
                                //  _gethelpfromBloc.add(clickGetHelpmenuevent(id: index));
                                //  print(index);

                                // if (index == 0) {
                                //   // Navigator.of(context).push(MaterialPageRoute(
                                //   //     builder: (context) => AboutUsPage()));
                                // } else if (index == 1) {
                                //   // Navigator.of(context).push(MaterialPageRoute(
                                //   //     builder: (context) => AboutUsPage()));
                                // } else if (index == 2) {
                                //   // Navigator.of(context).push(MaterialPageRoute(
                                //   //     builder: (context) => AboutUsPage()));
                                // } else if (index == 3) {
                                //   // Navigator.of(context).push(MaterialPageRoute(
                                //   //     builder: (context) => SettingPage()));
                                // } else if (index == 4) {
                                //   // Navigator.of(context).push(MaterialPageRoute(
                                //   //     builder: (context) => AboutUsPage()));
                                // } else if (index == 5) {
                                //   // Navigator.of(context).push(MaterialPageRoute(
                                //   //     builder: (context) => AboutUsPage()));
                                // }
                              });
                        },
                      );
                    })),
                  ]),
            ),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    print("back called");

    /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return homedashboard(
                savealiferep: widget.savealiferep,
                accesstoken:widget.accesstoken,
                 id: Prefs.getInt("userid")!,
               );
             }));*/

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => homedashboard(
                  savealiferep: widget.savealiferep,
                  accesstoken: widget.accesstoken,
                  id: Prefs.getInt("userid")!,
                )),
        (Route<dynamic> route) => false);
    return true;
  }

  Widget _buildGetHelpMenuView(List<Gethelp> gethelpmenulist) {
    final screenSize = MediaQuery.of(context).size;
    print("gethelpmenu func called${gethelpmenulist.length}");

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(child:
                  // Text(
                  //   _lastSelected,
                  //   style: TextStyle(fontSize: 32.0),
                  // ),
                  LayoutBuilder(builder: (context, constraints) {
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  //const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: gethelpmenulist.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,

                    mainAxisSpacing: 10,

                    childAspectRatio: 2,

                    mainAxisExtent: Platform.isIOS
                        ? DeviceUtil.isPad
                            ? 200
                            : 150
                        : 150,
                    //150,

                    crossAxisCount: Platform.isIOS
                        ? DeviceUtil.isPad
                            ? 6
                            : 3
                        : 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child:
                            _cellItem(context, gethelpmenulist[index], index),
                        onTap: () {
                          if (ApiData.gridclickcount == 0) {
                            ApiData.gridclickcount = ApiData.gridclickcount + 1;
                            print("gridclickcount:${ApiData.gridclickcount}");

                            _gethelpfromBloc
                                .add(clickGetHelpmenuevent(id: index));
                          }
                          //  _gethelpfromBloc.add(clickGetHelpmenuevent(id: index));
                          //  print(index);

                          // if (index == 0) {
                          //   // Navigator.of(context).push(MaterialPageRoute(
                          //   //     builder: (context) => AboutUsPage()));
                          // } else if (index == 1) {
                          //   // Navigator.of(context).push(MaterialPageRoute(
                          //   //     builder: (context) => AboutUsPage()));
                          // } else if (index == 2) {
                          //   // Navigator.of(context).push(MaterialPageRoute(
                          //   //     builder: (context) => AboutUsPage()));
                          // } else if (index == 3) {
                          //   // Navigator.of(context).push(MaterialPageRoute(
                          //   //     builder: (context) => SettingPage()));
                          // } else if (index == 4) {
                          //   // Navigator.of(context).push(MaterialPageRoute(
                          //   //     builder: (context) => AboutUsPage()));
                          // } else if (index == 5) {
                          //   // Navigator.of(context).push(MaterialPageRoute(
                          //   //     builder: (context) => AboutUsPage()));
                          // }
                        });
                  },
                );
              })),
            ]),
      ),
    );
  }

  Widget _cellItem(BuildContext context, Gethelp gethelpmenulist, int pst) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            // width: 118,
            constraints: BoxConstraints(
              maxHeight: Platform.isIOS
                  ? DeviceUtil.isPad
                      ? 140
                      : 110
                  : 110, //double.infinity,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(width: 1, color: const Color(0xffF3F3F3)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffB4B4B4),
                    blurRadius: 5.0,
                  ),
                ],
                // color: data['color'].withOpacity(1.0),
                color: pst == 1
                    ? ThemeColor.orange
                    : pst == 2
                        ? ThemeColor.red
                        : pst == 3
                            ? ThemeColor.lightBlue
                            : pst == 4
                                ? ThemeColor.darkPink
                                : pst == 5
                                    ? ThemeColor.green
                                    : pst == 6
                                        ? ThemeColor.darkGray
                                        : ThemeColor.purple),

            child: Image.asset(
              //  data['icon'] + ".png",
              gethelpmenulist.menuicon.toString() + ".png",
              height: 70,
              width: 70,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              gethelpmenulist.menuname.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111111),
                  fontFamily: FontName.poppinsMedium),
            ),
          )
        ]);
  }
}
