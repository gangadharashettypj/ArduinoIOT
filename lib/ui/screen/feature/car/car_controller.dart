/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:arduinoiot/ui/screen/feature/car/controller_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarController extends StatefulWidget {
  @override
  _CarControllerState createState() => _CarControllerState();
}

class _CarControllerState extends State<CarController> {
  int direction;
  String statusText = "Start Server";
  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(statusText),
                Column(
                  children: <Widget>[
                    Container(
                      child: AbsorbPointer(
                        absorbing: false,
                        child: Radio(
                          value: 1,
                          groupValue: direction,
                          onChanged: (val) {
                            setState(() {
                              direction = 1;
                            });
                          },
                        ),
                      ),
                    ),
                    Text("Front")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: AbsorbPointer(
                            absorbing: false,
                            child: Radio(
                              value: 2,
                              groupValue: direction,
                              onChanged: (val) {
                                setState(() {
                                  direction = 2;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Left")
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: AbsorbPointer(
                            absorbing: false,
                            child: Radio(
                              value: 3,
                              groupValue: direction,
                              onChanged: (val) {
                                setState(() {
                                  direction = 3;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Right")
                      ],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: AbsorbPointer(
                        absorbing: false,
                        child: Radio(
                          value: 4,
                          groupValue: direction,
                          onChanged: (val) {
                            setState(() {
                              direction = 4;
                            });
                          },
                        ),
                      ),
                    ),
                    Text("Back")
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: ControllerWidget(
              onchanged: (val) {
                setState(() {
                  this.direction = val;
                });
                DeviceManager().sendData(
                  R.api.carController,
                  params: {'direction': '$val'},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int getDirection() {
    return this.direction;
  }

  void startListening() async {
    Server().registerService(R.api.carController,
        (Map<String, String> response) {
      setState(() {
        direction = int.parse(response['code']);
      });
    });
  }
}
