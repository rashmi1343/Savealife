import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:savealifedemoapp/Model/VerifyOTPResponse.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';

import 'package:savealifedemoapp/utils/Constant.dart';

import '../Model/Help/AcceptHelpRequestResponse.dart';
import '../Model/CountriesResponse.dart';
import '../Model/GetAllMenuResponse.dart';
import '../Model/GetAllUsersResponse.dart';
import '../Model/GetHelpMenuResponse.dart';
import '../Model/Getuserprofile.dart';
import '../Model/Help/GetRouteForMapResponse.dart';
import '../Model/Help/HelpAcceptedResponse.dart';
import '../Model/LoginResponse.dart';
import '../Model/NotificationResponse.dart';
import '../Model/Help/SendHelpRequestModel.dart';
import '../Model/SignUpResponse.dart';
import '../Model/StatesResponse.dart';
import '../Model/TokenUpdateResponse.dart';
import '../Model/UpdateProfileResponse.dart';
import '../Model/UpdateuserProfileRequest.dart';

import '../ui/Medical/NearByPlacesResponse.dart';
import '../ui/Signin/SigninPage.dart';
import '../utils/pref.dart';

class SaveaLifeRepository {
  Future<LoginResponse> signinApi(String? email, String? password) async {
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // print("fcmToken:$fcmToken");
    Prefs.getString("fcmToken");
    try {
      Map signinParam = {
        // "username": username,
        "email": email,
        "password": password
      }; //encode Map to JSON
      var body = utf8.encode(json.encode(signinParam));
      print("signinParam data:$signinParam");
      var response = await http
          .post(Uri.parse("${ApiConstant.url}auth/signin"),
              headers: {
                "Content-Type": "application/json",
              },
              body: body)
          .timeout(const Duration(seconds: 500));
      print("${response.statusCode}");
      print(response.body);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(res);
        return loginResponse;
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }
    // print('signinParam:$signinParam');
    //
    // HttpClient httpClient = HttpClient();
    // HttpClientRequest request =
    //     await httpClient.postUrl(Uri.parse("${ApiConstant.url}auth/signin"));
    // request.headers.set('content-type', 'application/json');
    // request.add(utf8.encode(json.encode(signinParam)));
    // HttpClientResponse response = await request.close();
    // String signinreply = await response.transform(utf8.decoder).join();
    //
    // print(signinreply);
    // httpClient.close();
    // final loginResponse = LoginResponse.fromJson(jsonDecode(signinreply));
    //
    // // fetchOTPDetails(loginResponse.accessToken);
    // //   salHomeApi(loginResponse.accessToken);
    // //   getHelpApi(loginResponse.accessToken);
    // //  getAllUsersApi(loginResponse.accessToken,loginResponse.id);
    // //  getUserProfileApi(loginResponse.accessToken, loginResponse.id);
    // return loginResponse;
  }

  Future<SignUpResponse> signupApi(String username, String email,
      String mobileNumber, String password, String deviceID) async {
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // print("fcmToken:$fcmToken");
    // Prefs.setString("fcmtoken", fcmToken.toString());
    // Prefs.getString("fcmToken");
    try {
      Map signUpParam = {
        "username": username,
        "email": email,
        "mobile": mobileNumber,
        "password": password,
        "deviceid": deviceID,
        "devtoken": Prefs.getString("fcmToken"),
        "devtype": Platform.isAndroid ? "Android" : "iOS",
      }; //encode Map to JSON
      var body = utf8.encode(json.encode(signUpParam));
      print("signUpParam data:$signUpParam");
      var response = await http
          .post(Uri.parse("${ApiConstant.url}auth/signup"),
              headers: {
                "Content-Type": "application/json",
              },
              body: body)
          .timeout(const Duration(seconds: 500));
      print("${response.statusCode}");
      print(response.body);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        final signupResponse = SignUpResponse.fromJson(res);
        Prefs.setBool('IsSignup', true);
        return signupResponse;
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }

    // print('signUpParam:$signUpParam');
    //
    // HttpClient httpClient = HttpClient();
    // HttpClientRequest request =
    //     await httpClient.postUrl(Uri.parse("${ApiConstant.url}auth/signup"));
    // request.headers.set('content-type', 'application/json');
    // request.add(utf8.encode(json.encode(signUpParam)));
    // HttpClientResponse response = await request.close();
    // String signUpreply = await response.transform(utf8.decoder).join();
    //
    // print("signUpreply:$signUpreply");
    // httpClient.close();
    //
    // var jsonReply = json.decode(signUpreply);
    // print("jsonReply:$jsonReply");
    // //print(jsonReply["status"]["errors"]);
    // final signupResponse = SignUpResponse.fromJson(jsonReply);
    // print("signupResponse:$signupResponse");
    // // verifyOtp(signupResponse.id,signupResponse.otp,);
    // Prefs.setBool('IsSignup', true);
    //
    // return signupResponse;
    //return "";
  }

  Future<VerifyOtpResponse> verifyOtp(int id, int otp) async {
    Map otpParam = {"id": id, "otp": otp};

    print('otpParam:$otpParam');

    HttpClient httpClient = HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse("${ApiConstant.url}item/verifyotp"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(otpParam)));
    HttpClientResponse response = await request.close();
    String otpreply = await response.transform(utf8.decoder).join();

    print("otpreply:$otpreply");
    httpClient.close();

    var otpjsonReply = json.decode(otpreply);
    print("otpjsonReply:$otpjsonReply");

    final otpResponse = VerifyOtpResponse.fromJson(otpjsonReply);
    print("otpResponse:$otpResponse");

    return otpResponse;
  }

  Future<List<Menu>?> salHomeApi(String? accesstoken) async {
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse("${ApiConstant.url}menu/getallmenu"));
    request.headers.set('x-access-token', accesstoken!);

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    var menujsonReply = json.decode(reply);

    print("menujsonReply:$menujsonReply");
    //print(jsonReply["status"]["errors"]);

    //   final allmenuResponse = Menu.fromJson(jsonReply);
    // print("allmenuResponse:$allmenuResponse");
    // return allmenuResponse;
    httpClient.close();
    List<Menu> menulist = [];
    if (response.statusCode == 200) {
      print('response:$response.body');

      Map decoded = menujsonReply;

      for (var objmenulist in decoded["menu"]) {
        menulist.add(Menu(
            id: objmenulist["id"],
            menuname: objmenulist["menuname"],
            menuslug: objmenulist["menuslug"],
            createdAt: objmenulist["createdAt"],
            updatedAt: objmenulist["updatedAt"],
            menuicon: objmenulist["menuicon"]));
      }

      return menulist;
    }
    if (response.statusCode == 401) {
      print("statusCode:${response.statusCode}");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           SigninPage(saveliferepo: SaveaLifeRepository())),
      // );
      return menulist;
    } else {
      throw Exception('Failed to load menu');
    }
  }

  Future<List<Gethelp>?> getHelpApi(String? accesstoken) async {
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("${ApiConstant.url}menu/gethelpmenu"));
    request.headers.set('x-access-token', accesstoken!);

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    var gethelpjsonReply = json.decode(reply);

    print("gethelpjsonReply:$gethelpjsonReply");

    httpClient.close();
    List<Gethelp> gethelplist = [];
    if (response.statusCode == 200) {
      print('response:$response.body');

      Map decoded = gethelpjsonReply;

      for (var objhelplist in decoded["gethelp"]) {
        gethelplist.add(Gethelp(
            id: objhelplist["id"],
            menuname: objhelplist["menuname"],
            menuslug: objhelplist["menuslug"],
            createdAt: objhelplist["createdAt"],
            updatedAt: objhelplist["updatedAt"],
            menuicon: objhelplist["menuicon"]));
      }

      return gethelplist;
    }
    if (response.statusCode == 401) {
      print("statusCode:${response.statusCode}");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           SigninPage(saveliferepo: SaveaLifeRepository())),
      // );
      return gethelplist;
    } else {
      throw Exception('Failed to load get help menu');
    }
  }

  Future<List<User>?> getAllUsersApi(String? accesstoken, int? id) async {
    HttpClient httpClient = HttpClient();

    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("${ApiConstant.url}user/getallusers?id=$id"));
    request.headers.set('x-access-token', accesstoken!);

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    var userjsonReply = json.decode(reply);

    print("userjsonReply:$userjsonReply");

    httpClient.close();

    if (response.statusCode == 200) {
      print('response:$response.body');

      Map decoded = userjsonReply;
      List<User> getalluserlist = [];

      // if (getalluserlist.isEmpty) {
      //   Fluttertoast.showToast(
      //       msg: "No members to show",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIos: 1,
      //       backgroundColor: Color(0xff254fd5),
      //       textColor: Colors.white);
      // } else {

      for (var objuserlist in decoded["Users"]) {
        getalluserlist.add(User(
          id: objuserlist["id"],
          username: objuserlist["username"],
          email: objuserlist["email"],
          mobile: objuserlist["mobile"],
          address: objuserlist["address"],
          city: objuserlist["city"],
          pincode: objuserlist["pincode"],
          name: objuserlist["name"],
          deviceid: objuserlist["deviceid"],
          devtoken: objuserlist["devtoken"],
          devtype: objuserlist["devtype"],
          lat: objuserlist["lat"],
          long: objuserlist["long"],
        ));
      }
      //  }

      print("getalluserlist:${getalluserlist.length}");

      return getalluserlist;
    } else {
      throw Exception('Failed to load all users');
    }
  }



  Future<NotificationResponse> messagenotificationApi(
      String recieverdevtoken, String message) async {
    Map messageParam = {
      "registrationToken": recieverdevtoken,
      "message": message
    };

    print('messageParam:$messageParam');

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "${ApiConstant.firebaseNotificationUrl}firebase/notification"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(messageParam)));
    HttpClientResponse response = await request.close();
    String messagereply = await response.transform(utf8.decoder).join();

    print("messagereply:$messagereply");
    httpClient.close();

    var messagejsonReply = json.decode(messagereply);
    print("messagejsonReply:$messagejsonReply");
    //print(jsonReply["status"]["errors"]);
    final notificationResponse =
        NotificationResponse.fromJson(messagejsonReply);
    print("notificationResponse:$notificationResponse");

    return notificationResponse;
  }

  Future<List<Country>?> getCountriesApi(String? accesstoken) async {
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("${ApiConstant.url}item/getcountries"));
    request.headers.set('x-access-token', accesstoken!);

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    var getcountryjsonReply = json.decode(reply);

    print("getcountryjsonReply:$getcountryjsonReply");

    httpClient.close();

    if (response.statusCode == 200) {
      print('response:$response.body');

      Map decoded = getcountryjsonReply;
      List<Country> getcountrylist = [];
      for (var objcountrylist in decoded["countries"]) {
        getcountrylist.add(Country(
            name: objcountrylist['name'],
            code: objcountrylist['code'],
            dialCode: objcountrylist['dial_code']));
      }

      return getcountrylist;
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<StatesResponse> getStatesApi(
      String? accesstoken, String countrycode) async {
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient.getUrl(
        Uri.parse("${ApiConstant.url}item/getstates?countrycode=$countrycode"));
    request.headers.set('x-access-token', accesstoken!);

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    var getstatesjsonReply = json.decode(reply);

    print("getstatesjsonReply:$getstatesjsonReply");

    httpClient.close();

    final allStatesResponse = StatesResponse.fromJson(getstatesjsonReply);
    print("allStatesResponse:$allStatesResponse");
    return allStatesResponse;
  }

  Future<GetUserProfile> getUserProfileApi(String? accesstoken, int? id) async {
    GetUserProfile emptyprofileData = const GetUserProfile(
        id: 0,
        username: '',
        email: '',
        mobile: '',
        address: '',
        country: '',
        city: '',
        pincode: '',
        name: '');

    try {
      Map data = {
        'id': id,
      };

      //encode Map to JSON

      var body = utf8.encode(json.encode(data));

      print("data:$data");

      var response = await http
          .post(Uri.parse("${ApiConstant.url}item/userprofile"),
              headers: {
                "Content-Type": "application/json",
                "x-access-token": accesstoken ?? "",
              },
              body: body)
          .timeout(const Duration(seconds: 500));

      print("${response.statusCode}");

      print(response.body);

      if (response.statusCode == 200) {
        var userProfileJson = json.decode(response.body);

        final profileData = GetUserProfile.fromJson(userProfileJson);

        print(profileData.id);

        print(profileData.username);

        return profileData;
      }

      if (response.statusCode == 401) {
        return emptyprofileData;
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }
  }

  Future<UpdateProfileResponse> UpdateProfileApi(
      String? accesstoken, UpdateuserProfileRequest userobj) async {
    try {
      Map data = userobj.toJson();

      //encode Map to JSON

      var body = utf8.encode(json.encode(data));

      print("data:$data");

      var response = await http
          .post(Uri.parse("${ApiConstant.url}user/updateuser"),
              headers: {
                "Content-Type": "application/json",
                "x-access-token": accesstoken ?? "",
              },
              body: body)
          .timeout(const Duration(seconds: 500));

      print("${response.statusCode}");

      print(response.body);

      if (response.statusCode == 200) {
        var userProfileJson = json.decode(response.body);

        final profileData = UpdateProfileResponse.fromJson(userProfileJson);

        print(profileData.status);

        print(profileData.message);

        return profileData;
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }
  }

  Future<String> sendHelpRequest(
      SendHelpRequestModel sendHelpRequestModel, String accesstoken) async {
    try {
      Map sendHelpReqParam = sendHelpRequestModel.toJson(); //encode Map to JSON
      var body = utf8.encode(json.encode(sendHelpReqParam));
      print("sendHelpReqParam data:$sendHelpReqParam");
      var response = await http
          .post(Uri.parse("${ApiConstant.url}sendhelprequest"),
              headers: {
                "Content-Type": "application/json",
                "x-access-token": accesstoken,
              },
              body: body)
          .timeout(const Duration(seconds: 500));
      print("${response.statusCode}");
      print(response.body);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        Prefs.setInt("helprequestid", res['helprequestid']);
        print("helprequestid: " + res['helprequestid']);

        return res['message'];
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }
  }

  final client = Dio();

  Future<List<Userhelprequest>> gethelprequestbyrecevierdeviceid() async {
    Map helprequestParam = {
      'to_user_id': Prefs.getInt("userid").toString(),
    };
    print("helprequestParam:$helprequestParam");

    final response = await http.post(
        Uri.parse("${ApiConstant.url}gethelprequestbyrecevierdeviceid"),
        body: helprequestParam);
    print("helprequestresponse:$response");
    if (response.statusCode == 200) {
      // return json.decode(response.body);
      //   var jsonResponse = json.decode(response.body);
      // print("helprequestresponse:$jsonResponse");
      //   return jsonResponse["Userhelprequest"];
      List<dynamic> data = jsonDecode(response.body)['Userhelprequest'];
      List<Userhelprequest> list = [];

      list = data.map((item) => Userhelprequest.fromJson(item)).toList();

      // Prefs.setString("receivedevtokn", list[0].toDevToken.toString());
      // Prefs.setInt("accepteduserhelpid", list[0].id);

      return list;
    } else {
      throw Exception('Failed to help request');
    }
  }

  Future<HelpAcceptedResponse> helpAcceptedApi(
      int helpaccepted,
      int helprequestid,
      String message,
      String receivername,
      String receiveremail,
      String receivermobile) async {
    Map acceptedhelpParam = {
      "accepted_dev_id": Prefs.getString("deviceid"),
      "accepted_dev_token": Prefs.getString("fcmToken"),
      "accepted_user_id": Prefs.getInt("userid"),
      "helptype": "1",
      "Address": Prefs.getString("ProfileAddress"),
      "ishelpaccepted": helpaccepted,
      "helprequestid": helprequestid,
      "message": message,
      "lat": Prefs.getDouble("Latitude"),
      "long": Prefs.getDouble("Longitude"),
      "receivername": receivername,
      "receiveremail": receiveremail,
      "receivermobile": receivermobile
    };

    print("acceptedhelpParam:$acceptedhelpParam");
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient
        .postUrl(Uri.parse("${ApiConstant.url}helprequestaccepted"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(acceptedhelpParam)));
    HttpClientResponse response = await request.close();
    String acceptedhelpreply = await response.transform(utf8.decoder).join();

    print("acceptedhelpreply:$acceptedhelpreply");
    httpClient.close();

    var acceptedhelpjsonReply = json.decode(acceptedhelpreply);
    print("acceptedhelpjsonReply:$acceptedhelpjsonReply");

    final acceptedHelpResponse =
        HelpAcceptedResponse.fromJson(acceptedhelpjsonReply);
    print("acceptedHelpResponse:$acceptedHelpResponse");

    return acceptedHelpResponse;
  }

  Future<GetRouteForMapResponse> getrouteformapApi(int helprequestid) async {
    Map GetRouteForMapParam = {"helprequestid": helprequestid};

    print("GetRouteForMapParam:$GetRouteForMapParam");
    HttpClient httpClient = HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse("${ApiConstant.url}getrouteformap"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(GetRouteForMapParam)));
    HttpClientResponse response = await request.close();
    String GetRouteForMapreply = await response.transform(utf8.decoder).join();

    print("GetRouteForMapreply:$GetRouteForMapreply");
    httpClient.close();

    var GetRouteForMapjsonReply = json.decode(GetRouteForMapreply);
    print("GetRouteForMapjsonReply:$GetRouteForMapjsonReply");

    final getrouteresponse =
        GetRouteForMapResponse.fromJson(GetRouteForMapjsonReply);
    print("GetRouteForMapResponse:$GetRouteForMapResponse");

    return getrouteresponse;
  }

  Future<TokenUpdateResponse> tokenupdateapi(String token) async {
    try {
      Map tokenupdateMapParam = {
        "devtoken": token,
        "deviceid": Prefs.getString("deviceid"),
        "id":Prefs.getInt("userid")
      };
      var body = utf8.encode(json.encode(tokenupdateMapParam));
      print("tokenupdateMapParam data:$tokenupdateMapParam");
      var response = await http
          .post(Uri.parse("${ApiConstant.url}item/updatedfcmtoken"),
              headers: {
                "Content-Type": "application/json",
              },
              body: body)
          .timeout(const Duration(seconds: 500));
      print("${response.statusCode}");
      print(response.body);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        final tokenupdateresponse = TokenUpdateResponse.fromJson(res);
        return tokenupdateresponse;
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }
    // Map tokenupdateMapParam = {"devtoken": token,"deviceid":Prefs.getString("deviceid")};
    //
    // print("tokenupdateMapParam:$tokenupdateMapParam");
    // HttpClient httpClient = HttpClient();
    // HttpClientRequest request =
    // await httpClient.postUrl(Uri.parse("${ApiConstant.url}item/updatedfcmtoken"));
    // request.headers.set('content-type', 'application/json');
    // request.add(utf8.encode(json.encode(tokenupdateMapParam)));
    // HttpClientResponse response = await request.close();
    // String tokenupdateMapreply = await response.transform(utf8.decoder).join();
    //
    // print("tokenupdateMapreply:$tokenupdateMapreply");
    // httpClient.close();
    //
    // var tokenupdateMapjsonReply = json.decode(tokenupdateMapreply);
    // print("tokenupdateMapjsonReply:$tokenupdateMapjsonReply");
    //
    // final tokenupdateresponse =
    // TokenUpdateResponse.fromJson(tokenupdateMapjsonReply);
    // print("tokenupdateresponse:$tokenupdateresponse");
    //
    // return tokenupdateresponse;
  }
  Future<List<Results>> getNearestPlaces(String title,double? lat,double? long) async {
    String hospitalsSearchEndPoint =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${long}&radius=5000&types=${title}&sensor=true&key=AIzaSyCcLgRIDZsVGKCMB-YHDiEMvhB-DDW6MR4";
    try {
      var hospitalresponse = await http.get(Uri.parse(hospitalsSearchEndPoint));
      List data = jsonDecode(hospitalresponse.body)['results'];
      List<Results>? hospitalresults = [];


      hospitalresults = data.map((item) => Results.fromJson(item)).toList();

      return hospitalresults;
    } on SocketException catch (e) {
      throw Exception('Failed to load $e');
    }
  }
}
