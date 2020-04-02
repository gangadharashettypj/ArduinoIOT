/*
 * @Author GS
 */
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
            height: 30,
          ),
          Container(
            child: RaisedButton(
              child: Text("Front"),
              onPressed: () => onchanged(1),
              onLongPress: () => onchanged(1),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text("Left"),
                  onPressed: () => onchanged(2),
                  onLongPress: () => onchanged(2),
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text("Right"),
                  onPressed: () => onchanged(3),
                  onLongPress: () => onchanged(3),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: RaisedButton(
              child: Text("Back"),
              onPressed: () => onchanged(4),
              onLongPress: () => onchanged(4),
            ),
          ),
        ],
      ),
    );
  }
}
