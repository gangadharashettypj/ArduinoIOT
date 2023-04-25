import 'package:arduino_iot_v2/db/db.dart';
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/ui/screen/home/home.dart';
import 'package:arduino_iot_v2/ui/screen/splash.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbInstance.register();
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
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        R.routes.splash: (BuildContext context) => const SplashScreen(),
        R.routes.home: (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
