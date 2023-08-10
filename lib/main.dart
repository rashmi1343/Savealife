import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:savealifedemoapp/ui/Chat/ChatPage.dart';
import 'package:savealifedemoapp/ui/GetHelpFrom/GetHelpMenuPage.dart';
import 'package:savealifedemoapp/ui/HelpRequest/HelpRequest.dart';
import 'package:savealifedemoapp/ui/HomeDashboard/homedashboard.dart';
import 'package:savealifedemoapp/ui/Signin/SigninPage.dart';
import 'package:savealifedemoapp/ui/Userlocation/MapViewRoute.dart';
import 'package:savealifedemoapp/utils/Constant.dart';
import 'package:savealifedemoapp/utils/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:savealifedemoapp/ui/Splash/SplashPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Model/TokenUpdateResponse.dart';
import 'Repository/SaveALifeRepository.dart';
import 'ui/Signup/Validation/validation_provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);

  print(" background title: ${message.notification!.title}");
  print(" background body: ${message.notification!.body}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }
  await Prefs.init();

  if (Platform.isIOS) {
    requestAndRegisterNotificationInIOS();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

void requestAndRegisterNotificationInIOS() async {
  late final FirebaseMessaging messaging;

  // 1. Instantiate Firebase Messaging
  messaging = FirebaseMessaging.instance;

  // 2. On iOS, this helps to take the user permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    String? token = await messaging.getToken();
    print("The token is ${token!}");
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String? title;
  String? body;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? fltNotification;

  @override
  void initState() {
    super.initState();
    //  FirebaseMessaging.onMessage.listen(showFlutterNotification);
    getDeviceDetails();
    initMessaging();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp  event was published: $message');
      RemoteNotification? notification = message.notification;
      title = notification!.title;
      body = notification.body;
      print("message title:$title");
      print("message body:$body");

      // String? text = widget.otp.toString();
      // List<String>? result = text.split('');
      //
      // print("result:${result}");
      if (title!.contains("Chat")) {
        if (Prefs.getString("accesstoken")!.isNotEmpty) {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                      savealiferep: SaveaLifeRepository(),
                      accesstoken: Prefs.getString("accesstoken").toString(),
                      id: Prefs.getInt("userid")!)));
        } else {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) =>
                      SigninPage(saveliferepo: SaveaLifeRepository())));
        }
      } else {
        // FOR MAP request
        if (Prefs.getInt("sender") == 1) {
          // sender who need help who send request first time

          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => MapViewRoute(
                      accesstoken: Prefs.getString("accesstoken").toString())));
          Prefs.remove("sender");
        } else {
          // Receiver who give help
          Navigator.push(navigatorKey.currentState!.context,
              MaterialPageRoute(builder: (context) => HelpRequest()));
        }
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {});
    });
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSetting = InitializationSettings(android: androiInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification!.initialize(initSetting);
    var androidDetails = AndroidNotificationDetails('1', 'channelName');

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        fltNotification!.show(notification.hashCode, notification.title,
            notification.body, generalNotificationDetails);
      }
      title = notification!.title;
      body = notification.body;
      print("message title:$title");
      print("message body:$body");
      if (title!.contains("Chat")) {
        if (Prefs.getString("accesstoken")!.isNotEmpty) {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                      savealiferep: SaveaLifeRepository(),
                      accesstoken: Prefs.getString("accesstoken").toString(),
                      id: Prefs.getInt("userid")!)));
        } else {
          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) =>
                      SigninPage(saveliferepo: SaveaLifeRepository())));
        }
      } else {
        // FOR MAP request
        if (Prefs.getInt("sender") == 1) {
          // sender who need help who send request first time

          Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => MapViewRoute(
                      accesstoken: Prefs.getString("accesstoken").toString())));
          Prefs.remove("sender");
        } else {
          // Receiver who give help
          Navigator.push(navigatorKey.currentState!.context,
              MaterialPageRoute(builder: (context) => HelpRequest()));
        }
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {});
    });
  }

  Future<TokenUpdateResponse> tokenupdateapi(String token) async {
    try {
      Map tokenupdateMapParam = {
        "devtoken": token,
        "deviceid": Prefs.getString("deviceid")
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

  String deviceID = '';

  getDeviceDetails() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcmToken:$fcmToken");
    Prefs.setString("fcmToken", fcmToken.toString());
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceID = build.androidId!;
        print("DEVICE-ID : ${deviceID}");

        Prefs.setString("deviceid", deviceID);

        SaveaLifeRepository().tokenupdateapi(fcmToken!);

        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          // deviceName = data.name;
          // deviceVersion = data.systemVersion;
          deviceID = data.identifierForVendor!;
          print("iOS DEVICEID : ${deviceID}");
          Prefs.setString("deviceid", deviceID);

          // getDiscussionDatabymenuid(widget.currentmenuitem.menuId);
        });

        //UUID for iOS

        SaveaLifeRepository().tokenupdateapi(fcmToken!);
      }

      // print('Device Info: ${deviceName}, ${deviceVersion}, ${deviceID}');
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ValidationProvider(),
        // ← create/init your state model
        child: OverlaySupport(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            //  home:  HelpRequest(),
            //  home: MapViewRoute(accesstoken: Prefs.getString("accesstoken").toString(),),
            home: SplashPage(),

            // home: isLoggedIn ? SplashPage() : SigninPage(saveliferepo: SaveaLifeRepository(),),
            // BlocProvider(
            //   create:(context) => SignupBloc(saveALiferepository: SaveaLifeRepository()),
            //   child: SignupPage(repoSaveaLife: SaveaLifeRepository())
            // )
          ),
        ));
  }
}
