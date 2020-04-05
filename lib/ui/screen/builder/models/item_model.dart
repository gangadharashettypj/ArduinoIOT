/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';

class ItemModel {
  String name;
  int id;
  String textColor = "#AA000000";
  String bgColor = '#FFFFFF';
  double margin = 0;
  double padding = 0;
  ConnectionType connectionType = ConnectionType.HTTP;

  ItemModel(
      {this.name,
      this.id,
      this.textColor,
      this.bgColor,
      this.margin,
      this.padding,
      this.connectionType});
}
