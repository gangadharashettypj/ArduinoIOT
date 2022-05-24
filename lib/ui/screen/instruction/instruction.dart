/*
 * @Author GS
 */

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:flutter/material.dart';

class InstructionScreen extends StatefulWidget {
  @override
  _InstructionScreenState createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  var image = R.image.instruction1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Stress Tracker',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, R.routes.about, arguments: false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (image == R.image.instruction1) Container(),
                if (image == R.image.instruction2)
                  FloatingActionButton(
                    heroTag: 'two',
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        image = R.image.instruction1;
                      });
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: R.color.primary,
                      size: 50,
                    ),
                  ),
                FloatingActionButton(
                  heroTag: 'one',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if (image == R.image.instruction1) {
                      setState(() {
                        image = R.image.instruction2;
                      });
                    } else {
                      Navigator.pushNamed(
                        context,
                        R.routes.data,
                      );
                    }
                  },
                  child: Icon(
                    Icons.chevron_right,
                    color: R.color.primary,
                    size: 50,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: R.color.primary,
    );
  }
}
