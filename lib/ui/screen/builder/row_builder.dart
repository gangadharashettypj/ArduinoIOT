/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/ui/screen/builder/models/item_model.dart';
import 'package:arduinoiot/ui/screen/feature/widgets_list.dart';
import 'package:flutter/material.dart';

class RowBuilder extends StatefulWidget {
  List<ItemModel> items;
  RowBuilder({@required this.items});
  @override
  _RowBuilderState createState() => _RowBuilderState(items: this.items);
}

class _RowBuilderState extends State<RowBuilder> {
  List<ItemModel> items;
  _RowBuilderState({@required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
//        physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: <Widget>[
            ...buildItems(items),
            RaisedButton(
              color: R.color.primary,
              child: Text(
                'Add Items',
                style: TextStyle(color: R.color.opposite),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  child: Container(
                    margin: EdgeInsets.all(50),
                    child: ListView(
                      shrinkWrap: true,
                      children: getWidgetLists(),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildItems(List<ItemModel> items) {
    return items.map((item) {
      return Container(
        child: widgetsList[item.name],
      );
    }).toList();
  }

  List<Widget> getWidgetLists() {
    List<Widget> widgets = [];
    widgetsList.forEach((key, value) {
      widgets.add(
        Material(
          child: InkWell(
            child: ListTile(
              title: Text(key),
              subtitle: SizedBox(
                height: 200,
                child: Icon(Icons.slideshow),
              ),
            ),
            onTap: () {
              setState(() {
                items.add(ItemModel(name: key));
                Navigator.pop(context, true);
              });
            },
          ),
        ),
      );
    });
    return widgets;
  }
}
