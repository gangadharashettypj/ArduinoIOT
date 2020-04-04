/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/util/shared_preference.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isOnline = false;
  @override
  void initState() {
    super.initState();
    SharedPreferenceUtil.readBool("ONLINE").then(
      (bool val) => setState(() {
        if (val != null) isOnline = val;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arduino IOT"),
        actions: <Widget>[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text("ONLINE"),
              Switch(
                value: isOnline,
                onChanged: (val) {
                  setState(() {
                    isOnline = val;
                  });
                  SharedPreferenceUtil.writeBool("ONLINE", val);
                },
                activeTrackColor: R.color.accent,
                inactiveTrackColor: R.color.lightGray,
                activeColor: R.color.opposite,
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView(
          children: <Widget>[
            Card(
              elevation: 4,
              child: InkWell(
                child: Container(
                  child: Center(
                    child: Text(
                      "Car",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: R.color.gray,
                      ),
                    ),
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, R.routes.car),
              ),
            ),
            Card(
              elevation: 4,
              child: InkWell(
                child: Container(
                  child: Center(
                    child: Text(
                      "Chat",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: R.color.gray,
                      ),
                    ),
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, R.routes.chat),
              ),
            ),
            Card(
              elevation: 4,
              child: InkWell(
                child: Container(
                  child: Center(
                    child: Text(
                      "Servo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: R.color.gray,
                      ),
                    ),
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, R.routes.servo),
              ),
            ),
            Card(
              elevation: 4,
              child: InkWell(
                child: Container(
                  child: Center(
                    child: Text(
                      "Joystick",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: R.color.gray,
                      ),
                    ),
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, R.routes.joystick),
              ),
            ),
          ],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
          ),
        ),
      ),
    );
  }
}
