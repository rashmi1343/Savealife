import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Repository/SaveALifeRepository.dart';
import '../../utils/CustomTextStyle.dart';
import '../../utils/pref.dart';
import '../HomeDashboard/homedashboard.dart';

class GetPhoneContactsPage extends StatefulWidget {
  const GetPhoneContactsPage({Key? key}) : super(key: key);
  @override
  _GetPhoneContactsPageState createState() => _GetPhoneContactsPageState();
}
class _GetPhoneContactsPageState extends State<GetPhoneContactsPage> {
  List<Contact>? contacts;
  @override
  void initState() {

    super.initState();
    getContact();
  }
  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);
      setState(() {});
    }
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
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar:AppBar(
            automaticallyImplyLeading: false,
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
              "Contacts",
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
                    Navigator.of(context, rootNavigator: true).pop(context);
                  },
                ),
              ),
            ),
          ),
          body: (contacts) == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: contacts!.length,
            itemBuilder: (BuildContext context, int index) {
              Uint8List? image = contacts![index].photo;
              String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
              return ListTile(
                  leading: (contacts![index].photo == null)
                      ? const CircleAvatar(child: Icon(Icons.person))
                      : CircleAvatar(backgroundImage: MemoryImage(image!)),
                  title: Text(
                      "${contacts![index].name.first} ${contacts![index].name.last}"),
                  subtitle: Text(num),
                  onTap: () {
                    if (contacts![index].phones.isNotEmpty) {
                      launch('tel: ${num}');
                    }
                  });
            },
          )),
    );
  }
}