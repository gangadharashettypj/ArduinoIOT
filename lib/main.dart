import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:arduinoiot/ui/screen/builder/builder.dart';
import 'package:arduinoiot/ui/screen/feature/car/car_controller.dart';
import 'package:arduinoiot/ui/screen/feature/chat/chat.dart';
import 'package:arduinoiot/ui/screen/feature/joystick/joystick.dart';
import 'package:arduinoiot/ui/screen/feature/servo/servo.dart';
import 'package:arduinoiot/ui/screen/home/home.dart';
import 'package:arduinoiot/ui/screen/home/trialer.dart';
import 'package:arduinoiot/ui/screen/rajashekar.dart';
import 'package:arduinoiot/ui/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    listenForNotifications();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      title: "NestBees",
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        R.routes.splash: (BuildContext context) => SplashScreen(),
        R.routes.home: (BuildContext context) => Home(),
        R.routes.trial: (BuildContext context) => Trail(),
        R.routes.car: (BuildContext context) => CarController(),
        R.routes.chat: (BuildContext context) => Chat(),
        R.routes.joystick: (BuildContext context) => JoyStick(),
        R.routes.builder: (BuildContext context) => ScreenBuilder(),
        R.routes.rajashekar: (BuildContext context) => RajaShekar(),
        R.routes.servo: (BuildContext context) => Servo(
              max: 1000,
              min: 0,
              prefix: 's',
              suffix: '>>',
              onChange: (val) {
                print(val);
              },
            ),
      },
    );
  }

  void listenForNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onNotificationSelected);

    Server().registerService(R.api.notification,
        (Map<String, String> response) {
      raiseNotification(response['notificationMessage'],
          response['notificationBody'], response['notificationTitle']);
    });
  }

  Future onNotificationSelected(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.pushNamed(
      _context,
      '',
    );
  }

  void raiseNotification(String msg, String body, String title) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'arduino_iot_channel', 'arduino_iot', 'A notification for iot devices',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'msg');
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}
}
