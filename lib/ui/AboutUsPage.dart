import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';

import '../utils/Constant.dart';
import '../utils/CustomTextStyle.dart';
import '../utils/pref.dart';
import 'HomeDashboard/homedashboard.dart';


class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int _cIndex = 0;
  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });

  }

  @override
  void initState() {
    super.initState();

   // BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To Homedashboard Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
  //  Navigator.pop(context);
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => homedashboard(
  //             savealiferep: SaveaLifeRepository(),
  //             accesstoken: Prefs.getString("accesstoken").toString(),
  //             id: Prefs.getInt("userid")!,
  //          )));
     if (["homedashboardRoute"].contains(info.currentRoute(context))) return true;

    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
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

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        homedashboard(
          savealiferep: SaveaLifeRepository(),
          accesstoken: Prefs.getString("accesstoken").toString(),
          id: Prefs.getInt("userid")!,
        )), (Route<dynamic> route) => false);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop ,
      child: Scaffold(
        backgroundColor: Color(0xfff9fdfe),
        appBar: AppBar(
          toolbarHeight: 75,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Color(0xfff9fdfe),
          elevation: 0,
          title: Text(
            "About Us",
            style: const TextStyle(
              fontFamily: FontName.poppinsSemiBold,
              fontSize: 17,
              color: Color(0xff243444),
            ),
          ),
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
                  ApiData.gridclickcount = 0;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => homedashboard(
                        savealiferep: SaveaLifeRepository(),
                        accesstoken: Prefs.getString("accesstoken").toString(),
                        id: Prefs.getInt("userid")!,
                      )));
                },
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              //  height: 702,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        SvgPicture.asset(
                          "assets/images/clock_solid.svg",
                          width: 15,
                          height: 15,
                          color: const Color(0xfffe0000),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          child: const Text(
                            "Timely Help",
                            style: TextStyle(
                              fontFamily: FontName.poppinsMedium,
                              fontSize: 12,
                              color: Color(0xff243444),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        SvgPicture.asset(
                          "assets/images/handshake_angle_solid.svg",
                          width: 15,
                          height: 15,
                          color: const Color(0xfffe0000),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text(
                            "Help When you need",
                            style: TextStyle(
                              fontFamily: FontName.poppinsMedium,
                              fontSize: 12,
                              color: Color(0xff243444),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        SvgPicture.asset(
                          "assets/images/star_solid.svg",
                          width: 15,
                          height: 15,
                          color: const Color(0xfffe0000),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          child: const Text(
                            "Less Pressure on government and other bodies",
                            style: TextStyle(
                              fontFamily: FontName.poppinsMedium,
                              fontSize: 12,
                              color: Color(0xff243444),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "How We do this?",
                          style: TextStyle(
                            fontFamily: FontName.poppinsMedium,
                            fontSize: 15,
                            color: Color(0xff254fd5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "Simple Mobile App to connect everyone.",
                          style: TextStyle(
                            fontFamily: FontName.poppinsMedium,
                            fontSize: 12,
                            color: Color(0xff243444),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "The app will use smartphone technology and GPS software to help",
                          style: TextStyle(
                            fontFamily: FontName.poppinsMedium,
                            fontSize: 12,
                            color: Color(0xff243444),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "deliver aid(medical,social) to those who need it most.",
                          style: TextStyle(
                            fontFamily: FontName.poppinsMedium,
                            fontSize: 12,
                            color: Color(0xff243444),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "Who will be part of this?",
                          style: TextStyle(
                            fontFamily: FontName.poppinsSemiBold,
                            fontSize: 15,
                            color: Color(0xff254fd5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Wrap(
                              spacing: 8.0, // gap between adjacent chips

                              runSpacing: 4.0, // gap between lines

                              children: <Widget>[
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Individuals",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Business",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Hospitals",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //
                        //       padding: EdgeInsets.only(left: 25,right: 25,top: 8,bottom: 8),
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: Color(0xffededed),
                        //               width: 1.0,
                        //               style: BorderStyle.solid),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20))),
                        //       child: const Text(
                        //         "Individuals",
                        //         style: TextStyle(
                        //           fontFamily: 'GraphikMedium',
                        //           fontSize: 12,
                        //           color: Color(0xff243444),
                        //         ),
                        //       ),
                        //     )),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //       padding: EdgeInsets.only(
                        //           left: 25, right: 25, top: 8, bottom: 8),
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: Color(0xffededed),
                        //               width: 1.0,
                        //               style: BorderStyle.solid),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20))),
                        //       child: const Text(
                        //         "Business",
                        //         style: TextStyle(
                        //           fontFamily: 'GraphikMedium',
                        //           fontSize: 12,
                        //           color: Color(0xff243444),
                        //         ),
                        //       ),
                        //     )),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //       padding: EdgeInsets.only(
                        //           left: 25, right: 25, top: 8, bottom: 8),
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: Color(0xffededed),
                        //               width: 1.0,
                        //               style: BorderStyle.solid),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20))),
                        //       child: const Text(
                        //         "Hospitals",
                        //         style: TextStyle(
                        //           fontFamily: 'GraphikMedium',
                        //           fontSize: 12,
                        //           color: Color(0xff243444),
                        //         ),
                        //       ),
                        //     )),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Wrap(
                              spacing: 8.0, // gap between adjacent chips

                              runSpacing: 4.0, // gap between lines

                              children: <Widget>[
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Schools",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Colleges",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Fire Brigade",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //       padding: EdgeInsets.only(
                        //           left: 25, right: 25, top: 8, bottom: 8),
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: Color(0xffededed),
                        //               width: 1.0,
                        //               style: BorderStyle.solid),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20))),
                        //       child: const Text(
                        //         "Schools",
                        //         style: TextStyle(
                        //           fontFamily: 'GraphikMedium',
                        //           fontSize: 12,
                        //           color: Color(0xff243444),
                        //         ),
                        //       ),
                        //     )),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //       padding: EdgeInsets.only(
                        //           left: 25, right: 25, top: 8, bottom: 8),
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: Color(0xffededed),
                        //               width: 1.0,
                        //               style: BorderStyle.solid),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20))),
                        //       child: const Text(
                        //         "Colleges",
                        //         style: TextStyle(
                        //           fontFamily: 'GraphikMedium',
                        //           fontSize: 12,
                        //           color: Color(0xff243444),
                        //         ),
                        //       ),
                        //     )),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //       padding: EdgeInsets.only(
                        //           left: 25, right: 25, top: 8, bottom: 8),
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //               color: Color(0xffededed),
                        //               width: 1.0,
                        //               style: BorderStyle.solid),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20))),
                        //       child: const Text(
                        //         "Fire Brigade",
                        //         style: TextStyle(
                        //           fontFamily: 'GraphikMedium',
                        //           fontSize: 12,
                        //           color: Color(0xff243444),
                        //         ),
                        //       ),
                        //     )),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Wrap(
                              spacing: 8.0, // gap between adjacent chips

                              runSpacing: 4.0, // gap between lines

                              children: <Widget>[
                                Chip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Color(0xffededed))),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  label: const Text(
                                    "Goverment",
                                    style: TextStyle(
                                      fontFamily: FontName.poppinsMedium,
                                      fontSize: 12,
                                      color: Color(0xff243444),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "Success",
                          style: TextStyle(
                            fontFamily: FontName.poppinsSemiBold,
                            fontSize: 15,
                            color: Color(0xff254fd5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "Even if one life can be saved,it will be a success",
                          style: TextStyle(
                            fontFamily: FontName.poppinsMedium,
                            fontSize: 12,
                            color: Color(0xff243444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: FABBottomAppBar(
        //   centerItemText: '',
        //   color: Colors.grey,
        //   selectedColor: Color.fromARGB(255, 12, 87, 216),
        //   notchedShape: CircularNotchedRectangle(),
        //   onTabSelected: _selectedTab,
        //   items: [
        //     FABBottomAppBarItem( iconData: "assets/images/log_out.png", text: ''),
        //     FABBottomAppBarItem(iconData: "assets/images/user.png", text: ''),
        //   ],
        //   backgroundColor: Colors.white,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: _buildFab(context),
      ),
    );
  }

  // Widget _buildFab(BuildContext context) {
  //   return AnchoredOverlay(
  //     showOverlay: true,
  //     overlayBuilder: (context, offset) {
  //       return CenterAbout(
  //         position: Offset(offset.dx, offset.dy * 35.0),
  //         child: SizedBox(),
  //         // FabWithIcons(
  //         //   icons: icons,
  //         //   onIconTapped: _selectedFab,
  //         // ),
  //       );
  //     },
  //     child: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.pop(context);
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) =>  SALHome()),
  //         // );
  //       },
  //       backgroundColor: Color.fromARGB(255, 12, 87, 216),
  //       child: Image.asset(
  //         "assets/images/home.png",
  //         height: 30,
  //         width: 30,
  //       ),
  //       elevation: 10.0,
  //     ),
  //   );
  // }
}
