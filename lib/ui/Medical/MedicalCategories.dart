import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savealifedemoapp/ui/Medical/NearByPlaces.dart';

import '../../Repository/SaveALifeRepository.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../GetHelpFrom/GetHelpMenuPage.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class MedicalCategories extends StatefulWidget {
  const MedicalCategories({Key? key}) : super(key: key);

  @override
  State<MedicalCategories> createState() => _MedicalCategoriesState();
}

class ListItem {
  String title;

  ListItem({
    required this.title,
  });
}

List ListImages = [
  "assets/images/doctor.png",
  "assets/images/hospital.png",
  "assets/images/pharmay.png",

];

class _MedicalCategoriesState extends State<MedicalCategories> {
  List<ListItem> _items = [
    ListItem(title: 'doctor'),
    ListItem(title: 'hospital'),
    ListItem(title: 'pharmacy'),

  ];

  Future<bool> _onWillPop() async {
    print("back called");



    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => GetHelpMenuPage(
              savealiferep:SaveaLifeRepository(),
              accesstoken:Prefs.getString("accesstoken").toString(),
              userid: Prefs.getInt("userid")!,
            )),
            (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 75,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: const Color(0xfff9fdfe),
          elevation: 0,
          title: const Text(
            "Categories",
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
                  // Navigator.of(context).pop();
                  ApiData.gridclickcount = 0;
                  // Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetHelpMenuPage(
                            savealiferep: SaveaLifeRepository(),
                            accesstoken:
                                Prefs.getString("accesstoken").toString(),
                            userid: Prefs.getInt("userid")!,
                          )));
                  //  Navigator.of(context, rootNavigator: true).pop(context);
                },
              ),
            ),
          ),
        ),
        body: Center(
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      NearByPlaces(title: _items[index].title)));
                            },
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              child: Card(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0))),
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.all(8.0),
                                child: ListTile(
                                    leading: Container(
                                      color: Colors.white,
                                      child: Image.asset(
                                        ListImages[index],
                                        height: 60,
                                        width: 100,
                                      ),
                                    ),
                                    title: Text(
                                      _items[index].title.capitalize(),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: FontName.poppinsRegular),
                                    )),
                              ),
                            ),
                          );
                        }),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
