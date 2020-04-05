/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/ui/screen/builder/models/row_model.dart';
import 'package:arduinoiot/ui/screen/builder/row_builder.dart';
import 'package:flutter/material.dart';

class ScreenBuilder extends StatefulWidget {
  List<RowModel> rows = [];
  @override
  _ScreenBuilderState createState() => _ScreenBuilderState(rows: this.rows);
}

class _ScreenBuilderState extends State<ScreenBuilder> {
  List<RowModel> rows;
  _ScreenBuilderState({@required this.rows});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
//              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                ...builder(rows),
              ],
            ),
          ),
          Container(
            child: RaisedButton(
              color: R.color.primary,
              child: Text(
                'Add Row',
                style: TextStyle(color: R.color.opposite),
              ),
              onPressed: () {
                setState(() {
                  rows.add(RowModel());
                });
              },
            ),
          )
        ],
      ),
    );
  }

  List<RowBuilder> builder(List<RowModel> rows) {
    return rows.map((row) {
      return RowBuilder(
        items: [],
      );
    }).toList();
  }
}
