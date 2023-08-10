import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savealifedemoapp/bloc/Gethelpmenu_bloc/gethelpmenu_bloc.dart';

import '../../Model/GetAllMenuResponse.dart';
import '../../Repository/SaveALifeRepository.dart';
import '../../bloc/Homedashboard_bloc/homedashboard_bloc.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../AboutUsPage.dart';
import '../GetHelpFrom/GetHelpContent.dart';
import '../GetHelpFrom/GetHelpMenuPage.dart';
import '../NavigationBar/layout.dart';
import '../SettingPage.dart';

class Dashboardcontent extends StatefulWidget {
  final SaveaLifeRepository savealiferep;
  String accesstoken;
  List<Menu> homemenucontent;
  late final homedashboardbloc hmdashbrdbloc;
  int userid;

  Dashboardcontent(
      {required this.homemenucontent,
      required this.savealiferep,
      required this.accesstoken,
      required this.hmdashbrdbloc,
        required this.userid})
      : super();

  @override
  _DashboardcontentState createState() => _DashboardcontentState();
}

class _DashboardcontentState extends State<Dashboardcontent>
    with TickerProviderStateMixin {
  String _lastSelected = 'TAB:0';

  List<Menu> get _menu => widget.homemenucontent;

  homedashboardbloc get _hmdashbrdbloc => widget.hmdashbrdbloc;

  @override
  void initState() {
    print("menu length " + _menu.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenSize = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    return _buildMenuView(_menu);
  }

  Widget _buildMenuView(List<Menu> menulist) {
    final screenSize = MediaQuery.of(context).size;
    print("menu func called" + menulist.length.toString());

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/logo512.png",
                height: 200,
                width: screenSize.width,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GetHelpMenuPage(
                      savealiferep: widget.savealiferep,
                      accesstoken: widget.accesstoken, userid: widget.userid,
                    )));
              },

              child:
            Container(
              alignment: Alignment.center,
              // width: 118,
              margin: EdgeInsets.all(10),

              constraints: const BoxConstraints(
                maxHeight: 110, //double.infinity,
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
                color: ThemeColor.red.withOpacity(1.0),
              ),
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/helping_hand.png",
                        height: 170,
                        width: 95,
                      ),
                      const Text(
                        "Get Help",
                        style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(child:
                // Text(
                //   _lastSelected,
                //   style: TextStyle(fontSize: 32.0),
                // ),
                LayoutBuilder(builder: (context, constraints) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                //const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: menulist.length,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

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
                      child: _cellItem(context, menulist[index], index),
                      onTap: () {
                        if( ApiData.gridclickcount==0) {
                          ApiData.gridclickcount =  ApiData.gridclickcount+1;
                          print("gridclickcount:${ApiData.gridclickcount}");

                          _hmdashbrdbloc
                              .add(clickhomedashboarditemevent(menuid: index));
                        }

                      });
                },
              );
            })),
          ],
    ));
  }

  Widget _cellItem(BuildContext context, Menu menulist, int pst) {
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
              menulist.menuicon.toString() + ".png",
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
              menulist.menuname.toString(),
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
