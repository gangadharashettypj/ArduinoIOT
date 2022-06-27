import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/ui/screen/data/data.dart';
import 'package:arduinoiot/ui/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.register();
  await DB.instance.clear();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
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
        R.routes.data: (BuildContext context) => DataScreen(),
      },
    );
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
}
