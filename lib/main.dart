import 'package:arduinoiot/ui/screen/feature/car/car_controller.dart';
import 'package:arduinoiot/ui/screen/home/home.dart';
import 'package:arduinoiot/ui/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      title: "NestBees",
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => SplashScreen(),
        '/home': (BuildContext context) => Home(),
        '/carController': (BuildContext context) => CarController(),
      },
    );
  }
}
