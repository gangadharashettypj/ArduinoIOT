/*
 * @Author GS
 */
/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PhSensor extends StatefulWidget {
  @override
  _PhSensorState createState() => _PhSensorState();
}

class _PhSensorState extends State<PhSensor> {
  int value = 0, moisture = 0;
  double temp = 0, humidity = 0;
  String motorStatus = 'On';
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
              "Refresh",
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
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.all(40),
                    child: Center(
                      child: Material(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Text(
                                    LocalData.title != ''
                                        ? LocalData.title
                                        : 'Title',
                                    style: TextStyle(
                                      color: R.color.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                margin: EdgeInsets.all(10),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Description',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                LocalData.description != ''
                                    ? LocalData.description
                                    : 'Description',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Project developed by',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                LocalData.students.split('~').length > 0
                                    ? LocalData.students.split('~')[0]
                                    : '1. Student 1',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                LocalData.students.split('~').length > 1
                                    ? LocalData.students.split('~')[1]
                                    : '2. Student 2',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                LocalData.students.split('~').length > 2
                                    ? LocalData.students.split('~')[2]
                                    : '3. Student 3',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                LocalData.students.split('~').length > 3
                                    ? LocalData.students.split('~')[3]
                                    : '4. Student 4',
                                style: TextStyle(
                                  color: R.color.gray,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 200,
                                child: RaisedButton(
                                  color: R.color.primary,
                                  child: Text(
                                    'CLose',
                                    style: TextStyle(
                                      color: R.color.opposite,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'PH Value',
                      style: TextStyle(
                        color: R.color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      value.toString(),
                      style: TextStyle(
                        color: R.color.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Temperature',
                      style: TextStyle(
                        color: R.color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      temp.toString(),
                      style: TextStyle(
                        color: R.color.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Humidity',
                      style: TextStyle(
                        color: R.color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      humidity.toString(),
                      style: TextStyle(
                        color: R.color.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Moisture',
                      style: TextStyle(
                        color: R.color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      moisture.toString(),
                      style: TextStyle(
                        color: R.color.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 200,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Motor Status:',
                      style: TextStyle(
                        color: R.color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      motorStatus,
                      style: TextStyle(
                        color: R.color.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: R.color.primary,
                          child: Text(
                            "Turn On Motor",
                            style: TextStyle(
                              color: R.color.opposite,
                            ),
                          ),
                          onPressed: () {
                            showPasswordDialog(context, () {
                              DeviceManager().sendData(
                                R.api.motor,
                                params: {
                                  'motor': 'ON',
                                },
                              );
                            }, () {});
                          },
                        ),
                        RaisedButton(
                          color: R.color.red,
                          child: Text(
                            "Turn Off Motor",
                            style: TextStyle(
                              color: R.color.opposite,
                            ),
                          ),
                          onPressed: () {
                            showPasswordDialog(context, () {
                              DeviceManager().sendData(
                                R.api.motor,
                                params: {
                                  'motor': 'OFF',
                                },
                              );
                            }, () {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPasswordDialog(BuildContext context, Function onSuccessCallback,
      Function onFailureCallback) {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(40),
          child: Center(
            child: Material(
              child: Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          'Verify Admin',
                          style: TextStyle(
                            color: R.color.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: R.color.primary,
                      child: Text(
                        "Verify",
                        style: TextStyle(
                          color: R.color.opposite,
                        ),
                      ),
                      onPressed: () {
                        if (passController.text == 'iamadmin') {
                          onSuccessCallback();
                        } else {
                          onFailureCallback();
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.ph, (Map<String, String> response) {
      setState(() {
        value = int.parse(response['ph']);
      });
    });
    DeviceManager().listenForData(R.api.moisture,
        (Map<String, String> response) {
      setState(() {
        moisture = int.parse(response['moisture']);
      });
    });
    DeviceManager().listenForData(R.api.motor, (Map<String, String> response) {
      setState(() {
        motorStatus = response['motor'];
      });
    });
    DeviceManager().listenForData(R.api.humi, (Map<String, String> response) {
      setState(() {
        humidity = double.parse(response['humi']);
      });
    });
    DeviceManager().listenForData(R.api.temp, (Map<String, String> response) {
      setState(() {
        temp = double.parse(response['temp']);
      });
    });
  }
}
