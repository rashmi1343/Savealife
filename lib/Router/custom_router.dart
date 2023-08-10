import 'package:flutter/material.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';
import 'package:savealifedemoapp/Router/route_constants.dart';
import 'package:savealifedemoapp/ui/HomeDashboard/homedashboard.dart';

import '../ui/GetHelpFrom/GetHelpMenuPage.dart';
import '../ui/Profile/Profilebasepage.dart';
import '../utils/pref.dart';


class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {


      case homedashboardRoute:
        return MaterialPageRoute(builder: (_) =>  homedashboard( savealiferep: SaveaLifeRepository(),
          accesstoken: Prefs.getString("accesstoken").toString(),
          id: Prefs.getInt("userid")!,));

      case gethelpdashboardRoute:
        return MaterialPageRoute(builder: (_) =>  GetHelpMenuPage( savealiferep: SaveaLifeRepository(),
          accesstoken: Prefs.getString("accesstoken").toString(),
          userid: Prefs.getInt("userid")!,));

      case profileRoute:
        return MaterialPageRoute(builder: (_) => Profilebasepage(
          Reposavealife: SaveaLifeRepository(),
          accesstoken:  Prefs.getString("accesstoken").toString(),
          userid: Prefs.getInt("userid")!
        ));





      default:
        return MaterialPageRoute(builder: (_) =>  homedashboard( savealiferep: SaveaLifeRepository(),
          accesstoken: Prefs.getString("accesstoken").toString(),
          id: Prefs.getInt("userid")!,));
    }
  }
}
