import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/ui/screen/about/about.dart';
import 'package:arduinoiot/ui/screen/data/data.dart';
import 'package:arduinoiot/ui/screen/form/form.dart';
import 'package:arduinoiot/ui/screen/form_personal/personal_form.dart';
import 'package:arduinoiot/ui/screen/home/home.dart';
import 'package:arduinoiot/ui/screen/instruction/instruction.dart';
import 'package:arduinoiot/ui/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.register();
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
        primarySwatch: MaterialColor(0xFF009889, {
          50: const Color(0xFF009889),
          100: const Color(0xFF009889),
          200: const Color(0xFF009889),
          300: const Color(0xFF009889),
          400: const Color(0xFF009889),
          500: const Color(0xFF009889),
          600: const Color(0xFF009889),
          700: const Color(0xFF009889),
          800: const Color(0xFF009889),
          900: const Color(0xFF009889)
        }),
      ),
      title: "NestBees",
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        R.routes.splash: (BuildContext context) => SplashScreen(),
        R.routes.home: (BuildContext context) => HomeScreen(),
        R.routes.form: (BuildContext context) => FormScreen(),
        R.routes.personalForm: (BuildContext context) => PersonalFormScreen(),
        R.routes.about: (BuildContext context) => AboutScreen(),
        R.routes.instruction: (BuildContext context) => InstructionScreen(),
        R.routes.data: (BuildContext context) => DataScreen(),
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
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onNotificationSelected);
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
}
