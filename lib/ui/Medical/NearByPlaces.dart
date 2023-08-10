import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../Repository/SaveALifeRepository.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../GetHelpFrom/GetHelpMenuPage.dart';
import 'MedicalCategories.dart';
import 'NearByMap.dart';
import 'NearByPlacesResponse.dart';

class NearByPlaces extends StatefulWidget {
  String? title;

  NearByPlaces({required this.title});

  @override
  State<StatefulWidget> createState() {
    return NearByPlacesState();
  }
}

class NearByPlacesState extends State<NearByPlaces> {
  late BuildContext searchdialogContext;
  TextEditingController editingController = TextEditingController();
  bool _searchBoolean = false;
  List<Results> placeslist = [];
  List<Results> AllPlaceslist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHospitalData();
  }

  getHospitalData() async {
    await SaveaLifeRepository()
        .getNearestPlaces(
            widget.title.toString(),
            Prefs.getDouble("Latitude")!.toDouble(),
            Prefs.getDouble("Longitude")!.toDouble())
        .then((value) {
      setState(() {
        AllPlaceslist.addAll(value);
        placeslist = AllPlaceslist;
        isLoading = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    print("back called");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MedicalCategories()),
        (Route<dynamic> route) => false);
    return true;
  }

  Widget _searchTextField() {
    return TextField(
      controller: editingController,

      onChanged: (searchText) {
        searchText = searchText.toLowerCase();
        setState(() {
          placeslist = AllPlaceslist.where((u) {
            var hospitalName = u.name!.toLowerCase();
            var located = u.vicinity!.toLowerCase();

            return hospitalName.contains(searchText) ||
                located.contains(searchText);
          }).toList();
        });
      },
      autofocus: true,
      //Display the keyboard when TextField is displayed
      cursorColor: Colors.black,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: FontName.poppinsRegular),
      textInputAction: TextInputAction.search,
      //Specify the action button on the keyboard
      decoration: const InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(
          color: Color(0xff254fd5),
        )),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(
          color: Color(0xff254fd5),
        )),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle(
            //Style of hintText
            color: Colors.grey,
            fontSize: 14,
            fontFamily: FontName.poppinsRegular),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xfff9fdfe),
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
          title: !_searchBoolean
              ? Text(
                  widget.title.toString().capitalize(),
                  style: TextStyle(
                    fontFamily: FontName.poppinsSemiBold,
                    fontSize: 17,
                    color: Color(0xff243444),
                  ),
                )
              : _searchTextField(),
          actions: !_searchBoolean
              ? [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchBoolean = true;
                      });
                    },
                    child: Container(
                      // padding: const EdgeInsets.only(left: 5),
                      margin: const EdgeInsets.only(right: 25),
                      height: 18,
                      width: 18,
                      child: SvgPicture.asset(
                        "assets/images/magnifying-glass.svg",
                        color: const Color(0xff111111),
                      ),
                    ),
                  )
                ]
              : [
                  IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Color(0xff000000),
                      ),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                        });
                      })
                ],
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
                      builder: (context) => MedicalCategories()
                      // GetHelpMenuPage(
                      //   savealiferep: SaveaLifeRepository(),
                      //   accesstoken:
                      //       Prefs.getString("accesstoken").toString(),
                      //   userid: Prefs.getInt("userid")!,
                      // )

                      ));
                  //  Navigator.of(context, rootNavigator: true).pop(context);
                },
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xff254fd5),
              ))
            : Card(
                elevation: 5,
                margin: const EdgeInsets.all(2),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                  ),
                  shrinkWrap: true,
                  itemCount: placeslist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        placeslist[index].icon.toString(),
                        height: 40,
                        width: 40,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 310,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xff254fd5),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Name",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff254fd5),
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                            )),
                                        Text(placeslist[index].name.toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontFamily:
                                                  FontName.poppinsRegular,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Address",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff254fd5),
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                            )),
                                        Text(
                                            placeslist[index]
                                                .vicinity
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontFamily:
                                                  FontName.poppinsRegular,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("User Ratings",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff254fd5),
                                                  fontFamily:
                                                      FontName.poppinsMedium,
                                                )),
                                            Text(
                                                placeslist[index]
                                                    .userRatingsTotal
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      FontName.poppinsLight,
                                                )),
                                          ],
                                        ),
                                        Center(
                                          child: SizedBox(
                                            width: 120.0,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff254fd5),
                                                  elevation: 3,
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  padding:
                                                      const EdgeInsets.all(5)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NearByMapRoute(
                                                                accesstoken: Prefs
                                                                        .getString(
                                                                            "accesstoken")
                                                                    .toString(),
                                                                placeslist:
                                                                    placeslist,
                                                                title: widget
                                                                    .title
                                                                    .toString())));
                                              },
                                              child: Text(
                                                "Directions",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: FontName
                                                        .poppinsRegular),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(placeslist[index].name.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: FontName.poppinsRegular,
                              )),
                        ],
                      ),
                    );
                  },
                )),

        // FutureBuilder<List<Results>>(
        //   future: SaveaLifeRepository().getNearestPlaces(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return
        //         ListView.separated(
        //         separatorBuilder: (context, index) => const Divider(
        //           color: Colors.grey,
        //         ),
        //         shrinkWrap: true,
        //         itemCount: snapshot.data!.length,
        //         itemBuilder: (context, index) {
        //           return ListTile(
        //             leading: Image.network(
        //               snapshot.data![index].icon.toString(),
        //               height: 40,
        //               width: 40,
        //             ),
        //             title: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(snapshot.data![index].name.toString(),
        //                     style: const TextStyle(
        //                       fontSize: 14,
        //                       fontFamily: FontName.poppinsRegular,
        //                     )),
        //                 const SizedBox(
        //                   height: 2,
        //                 ),
        //                 Text(snapshot.data![index].vicinity.toString(),
        //                     style: const TextStyle(
        //                       fontSize: 11,
        //                       fontFamily: FontName.poppinsRegular,
        //                     )),
        //               ],
        //             ),
        //           );
        //         },
        //       );
        //     } else if (snapshot.hasError) {
        //       return Text('${snapshot.error}');
        //     }
        //     return const Center(
        //         child: CircularProgressIndicator(
        //       color: Color(0xff254fd5),
        //     ));
        //   },
        // ),
      ),
    );
  }
}
