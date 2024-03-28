class GreenHouseModel {
  GreenHouseModel({
    this.temp = '',
    this.humidity = '',
    this.soil = '',
    this.light = false,
    this.sprinkler = false,
  });

  String temp;
  String humidity;
  String soil;
  bool light;
  bool sprinkler;

  factory GreenHouseModel.fromJson(Map<String, dynamic> json) {
    return GreenHouseModel(
      temp: json['temp'],
      humidity: json['humidity'],
      soil: json['soil'],
      light: json['light'],
      sprinkler: json['sprinkler'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['temp'] = temp;
    data['humidity'] = humidity;
    data['soil'] = soil;
    data['light'] = light;
    data['sprinkler'] = sprinkler;
    return data;
  }
}
