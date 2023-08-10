import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Model/CountriesResponse.dart';
import '../ui/NavigationBar/layout.dart';
import 'CustomTextStyle.dart';

class ThemeColor {
  static const lightBlue = Color(0xff3b83f7);
  static const purple = Color(0xff4e2a96);
  static const orange = Color(0xfff2903d);
  static const darkPink = Color(0xffe03755);
  static const green = Color(0xff5bc548);
  static const darkGray = Color(0xff5b6271);
  static const red = Color(0xffed3833);
  static const darkBlue = Color.fromARGB(0, 7, 53, 204);
  static const kPrimaryColor = Color(0xFF00BF6D);
  static const kSecondaryColor = Color(0xFFFE9901);
  static const kContentColorLightTheme = Color(0xFF1D1D35);
  static const kContentColorDarkTheme = Color(0xFFF5FCF9);
  static const kWarninngColor = Color(0xFFF3BB1C);
  static const kErrorColor = Color(0xFFF03738);

  static const kDefaultPadding = 20.0;
}

class ApiConstant {
//  static String url = "http://192.168.1.152:8080/api/";
//  static String url = "http://192.168.1.79:8080/api/";
  // static String url = "http://192.168.1.116:8080/api/";
  // static String url = "http://192.168.1.100:8080/api/";
 // static String url = "http://192.168.1.95:8080/api/";
 // static String url = "http://192.168.2.160:8080/api/";
  static String url = "http://192.168.1.104:3000/api/";
 // static String firebaseNotificationUrl = "http://192.168.1.95:8080/";
  static String firebaseNotificationUrl = "http://192.168.1.104:3000/";
  static String deviceToken = '';
}

class ApiData {
  static late Country countrieslist;
  static int gridclickcount = 0;

  static String deviceToken = '';
}

class DeviceUtil {
  static String get _getDeviceType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? 'phone' : 'ipad';
  }

  static bool get isPad {
    return _getDeviceType == 'ipad';
  }
}

PreferredSizeWidget commonAppBar(String title) {
  return AppBar(
    toolbarHeight: 75,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // <-- SEE HERE

      statusBarIconBrightness:
          Brightness.light, //<-- For Android SEE HERE (dark icons)

      statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
    ),
    backgroundColor: const Color(0xfff9fdfe),
    elevation: 0,
    centerTitle: false,
    title: AppBarTitle(title),
    leading: Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(left: 5),
        child: IconButton(
          alignment: Alignment.centerLeft,
          icon: Image.asset(
            "assets/images/back.png",
            color: Colors.black,
            height: 21,
            width: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    ),
  );
}

Widget AppBarTitle(String title) {
  return Transform(
    transform: Matrix4.translationValues(-18.0, 0.0, 0.0),
    child: Text(
      title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: FontName.poppinsBold,

        fontSize: 18,

        color: Colors.black, //Color(0xff243444),
      ),
    ),
  );
}

Widget buildFab(BuildContext context) {
  return AnchoredOverlay(
    showOverlay: true,
    overlayBuilder: (context, offset) {
      return CenterAbout(
        position: Offset(offset.dx, offset.dy * 35.0),
        child: const SizedBox(),
      );
    },
    child: FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color.fromARGB(255, 12, 87, 216),
      elevation: 10.0,
      child: Image.asset(
        "assets/images/home.png",
        height: 30,
        width: 30,
      ),
    ),
  );
}

Widget showloading() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
