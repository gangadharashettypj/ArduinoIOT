/*
 * @Author GS
 */
import 'package:flutter/material.dart';

class FeedbackWidget extends StatefulWidget {
  int direction;
  Function(int) onchanged;
  FeedbackWidget({@required this.direction, this.onchanged});
  @override
  _FeedbackWidgetState createState() =>
      _FeedbackWidgetState(direction: direction, onchanged: this.onchanged);
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  int direction;
  Function(int) onchanged;
  _FeedbackWidgetState({@required this.direction, this.onchanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
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
                        onchanged(direction);
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
                            onchanged(direction);
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
                            onchanged(direction);
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
                        onchanged(direction);
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
    );
  }
}
