import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app bar'),
      ),
      body: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Text('sdgf'),
            RaisedButton(
              onPressed: () {},
            ),
            RaisedButton(
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
