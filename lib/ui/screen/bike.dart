/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class BikeScreen extends StatefulWidget {
  @override
  _BikeScreenState createState() => _BikeScreenState();
}

class _BikeScreenState extends State<BikeScreen> {
  int numberOfCoins;
  int waterTimings;
  int waterLiters;

  @override
  void initState() {
    startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocalData.title != '' ? LocalData.title : 'Title',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Reconnect",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Response res = await HttpREST().get(
                R.api.setClientIP,
                params: {
                  'ip': 'sd',
                  'port': '2345',
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Total Coins: ${numberOfCoins == null ? '--' : numberOfCoins}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Timings: ${waterTimings == null ? '--' : waterTimings}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 30,
            // ),
            // Container(
            //   width: double.infinity,
            //   child: Card(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(20),
            //       ),
            //     ),
            //     elevation: 8,
            //     child: Container(
            //       margin: EdgeInsets.all(16),
            //       child: Text(
            //         'Liters: ${waterLiters == null ? '--' : waterLiters}',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 20,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: R.color.primary,
                  child: Text(
                    "Update Timings",
                    style: TextStyle(
                      color: R.color.opposite,
                    ),
                  ),
                  onPressed: () async {
                    String timing = '';
                    await showDialog<String>(
                      context: context,
                      child: Container(
                        child: AlertDialog(
                          contentPadding: const EdgeInsets.all(16.0),
                          content: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    labelText: 'Time in seconds',
                                  ),
                                  onChanged: (val) {
                                    timing = val;
                                  },
                                  maxLength: 2,
                                  keyboardType: TextInputType.number,
                                ),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            FlatButton(
                                child: const Text('Update'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  if (timing.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'enter a valid timings');
                                    return;
                                  }
                                  await DeviceManager()
                                      .sendData(R.api.setWaterTiming, params: {
                                    "time": timing,
                                  });
                                })
                          ],
                        ),
                      ),
                    );
                  },
                ),
                RaisedButton(
                  color: R.color.red,
                  child: Text(
                    "Reset Coins",
                    style: TextStyle(
                      color: R.color.opposite,
                    ),
                  ),
                  onPressed: () async {
                    await showDialog<String>(
                      context: context,
                      child: Container(
                        child: AlertDialog(
                          contentPadding: const EdgeInsets.all(16.0),
                          content: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Reset coins to 0'),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            FlatButton(
                                child: const Text('Reset'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await DeviceManager()
                                      .sendData(R.api.resetCoins);
                                })
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.numberOfCoins,
        (Map<String, String> response) {
      setState(() {
        numberOfCoins = int.parse(response['noOfCoins']);
      });
    });
    DeviceManager().listenForData(R.api.getWaterTiming,
        (Map<String, String> response) {
      setState(() {
        waterTimings = int.parse(response['getWaterTiming']);
      });
    });
    DeviceManager().listenForData(R.api.getWaterLiters,
        (Map<String, String> response) {
      setState(() {
        waterLiters = int.parse(response['getWaterLiters']);
      });
    });
  }
}
