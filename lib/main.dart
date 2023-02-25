import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/ui/screen/home/home.dart';
import 'package:arduino_iot_v2/ui/screen/splash.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      title: "NestBees",
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        R.routes.splash: (BuildContext context) => SplashScreen(),
        R.routes.home: (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
