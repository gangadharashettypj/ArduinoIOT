import 'package:arduino_iot_v2/db/db.dart';
import 'package:arduino_iot_v2/firebase_options.dart';
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/ui/screen/home/home.dart';
import 'package:arduino_iot_v2/ui/screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dbInstance.register();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.indigo,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      title: "ROBOT",
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        R.routes.splash: (BuildContext context) => const SplashScreen(),
        R.routes.home: (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
