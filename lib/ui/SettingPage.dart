import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Repository/SaveALifeRepository.dart';
import '../utils/Constant.dart';
import '../utils/CustomTextStyle.dart';
import '../utils/pref.dart';
import 'HomeDashboard/homedashboard.dart';
import 'NavigationBar/fab_bottom_app_bar.dart';
import 'NavigationBar/layout.dart';
import 'PhoneContacts/GetPhoneContactsPage.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _lastSelected = 'TAB: 0';
  bool personalContactisSwitched = false;
  bool publicisSwitched = false;
  bool contactisSwitched = false;

  // var isEnabled = false;
  final animationDuration = Duration(milliseconds: 300);

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  @override
  void initState() {
    super.initState();

    //BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To Homedashboard Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
    if (["homedashboardRoute"].contains(info.currentRoute(context))) return true;
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => homedashboard(
    //       savealiferep: SaveaLifeRepository(),
    //       accesstoken: Prefs.getString("accesstoken").toString(),
    //       id: Prefs.getInt("userid")!,
    //     )));
    // if (["docRoute"].contains(info.currentRoute(context))) return true;

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
          centerTitle: false,
          toolbarHeight: 75,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Color(0xfff9fdfe),
          elevation: 0,
          title: const Text(
            "Setting",
            style: TextStyle(
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
              // height: 702,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(2),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 22),
                        child: const Text(
                          "Get Help From",
                          style: TextStyle(
                            fontFamily: FontName.poppinsSemiBold,
                            fontSize: 15,
                            color: Color(0xff243444),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 22),
                            child: const Text(
                              "Personal Contacts",
                              style: TextStyle(
                                fontFamily: FontName.poppinsMedium,
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              personalContactisSwitched =
                                  !personalContactisSwitched;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GetPhoneContactsPage()));
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 22),
                            child: AnimatedContainer(
                              height: 25,
                              width: 45,
                              duration: animationDuration,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: personalContactisSwitched
                                    ? Color(0xff4dd865)
                                    : Color(0xffcccccc),
                              ),
                              child: AnimatedAlign(
                                duration: animationDuration,
                                alignment: personalContactisSwitched
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        // Container(
                        //
                        //   child: Switch(
                        //     value: personalisSwitched,
                        //     activeColor: Colors.green,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         personalisSwitched = value;
                        //       });
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 22),
                            child: const Text(
                              "General Public help",
                              style: TextStyle(
                                fontFamily: FontName.poppinsMedium,
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              publicisSwitched = !publicisSwitched;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 22),
                            child: AnimatedContainer(
                              height: 25,
                              width: 45,
                              duration: animationDuration,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: publicisSwitched
                                    ? Color(0xff4dd865)
                                    : Color(0xffcccccc),
                              ),
                              child: AnimatedAlign(
                                duration: animationDuration,
                                alignment: publicisSwitched
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        // Container(
                        //   child: Switch(
                        //     value: publicisSwitched,
                        //     activeColor: Colors.green,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         publicisSwitched = value;
                        //       });
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 22),
                            child: const Text(
                              "Show Contact Information",
                              style: TextStyle(
                                fontFamily: FontName.poppinsSemiBold,
                                fontSize: 15,
                                color: Color(0xff243444),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              contactisSwitched = !contactisSwitched;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 22),
                            child: AnimatedContainer(
                              height: 25,
                              width: 45,
                              duration: animationDuration,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: contactisSwitched
                                    ? Color(0xff4dd865)
                                    : Color(0xffcccccc),
                              ),
                              child: AnimatedAlign(
                                duration: animationDuration,
                                alignment: contactisSwitched
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Container(
                        //   child: Switch(
                        //     value: contactisSwitched,
                        //     activeColor: Colors.green,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         contactisSwitched = value;
                        //       });
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
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
        //     FABBottomAppBarItem(iconData: "assets/images/log_out.png", text: ''),
        //     FABBottomAppBarItem(iconData: "assets/images/user.png", text: ''),
        //   ],
        //   backgroundColor: Colors.white,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: _buildFab(context),
      ),
    );
  }
  //
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
