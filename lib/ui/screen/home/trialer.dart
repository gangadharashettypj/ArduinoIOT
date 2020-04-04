/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/util/shared_preference.dart';
import 'package:flutter/material.dart';

class Trail extends StatefulWidget {
  @override
  _TrailState createState() => _TrailState();
}

class _TrailState extends State<Trail> {
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
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
