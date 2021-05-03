/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/ui/screen/feature/chat/chat.dart';
import 'package:flutter/material.dart';

class RajaShekar extends StatefulWidget {
  @override
  _RajaShekarState createState() => _RajaShekarState();
}

class _RajaShekarState extends State<RajaShekar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocalData.title != '' ? LocalData.title : 'Title',
        ),
        actions: <Widget>[
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
      body: Chat(),
    );
  }
}
