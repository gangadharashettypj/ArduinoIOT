/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:flutter/material.dart';

class ControllerWidget extends StatefulWidget {
  Function(int) onchanged;
  ControllerWidget({this.onchanged});
  @override
  _ControllerWidgetState createState() =>
      _ControllerWidgetState(onchanged: this.onchanged);
}

class _ControllerWidgetState extends State<ControllerWidget> {
  Function(int) onchanged;
  _ControllerWidgetState({this.onchanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            color: R.color.primary,
            child: InkWell(
              onTap: () => onchanged(1),
              child: Container(
                margin:
                    EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                child: Text(
                  "Front",
                  style: TextStyle(
                    color: R.color.opposite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                color: R.color.primary,
                child: InkWell(
                  onTap: () => onchanged(2),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 40, right: 40, top: 20, bottom: 20),
                    child: Text(
                      "Left",
                      style: TextStyle(
                        color: R.color.opposite,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                color: R.color.primary,
                child: InkWell(
                  onTap: () => onchanged(3),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 40, right: 40, top: 20, bottom: 20),
                    child: Text(
                      "Right",
                      style: TextStyle(
                        color: R.color.opposite,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: R.color.primary,
            child: InkWell(
              onTap: () => onchanged(4),
              child: Container(
                margin:
                    EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: R.color.opposite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
