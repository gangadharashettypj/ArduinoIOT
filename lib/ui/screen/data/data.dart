/*
 * @Author GS
 */

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/widget/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  double linearResult = -1;
  double dnnResult = -1;

  Future<void> getAnalysis() async {
    /*
    2020,1,1,5,19.31,14.22,93.44,92.51,3.51,128.5,5.47,128.28
2020,1,1,6,19.33,13.98,92.06,92.64,3.6,124.03,5.26,123.93
2020,1,1,7,20.34,13.61,84.19,92.78,4.21,120.42,5.2,120.73
2020,1,1,8,21.73,12.88,73.19,92.89,4.46,118.09,5.3,118.72
2020,1,1,9,23.26,12.15,63.0,92.9,4.3,117.03,5.03,117.88
2020,1,1,10,24.87,11.66,54.94,92.87,3.86,115.01,4.51,115.86
2020,1,1,11,26.45,11.35,48.62,92.78,3.43,113.23,4.04,114.19
2020,1,1,12,27.68,11.11,44.38,92.65,3.07,113.24,3.66,114.32
2020,1,1,13,28.16,11.11,42.88,92.52,2.7,115.68,3.24,116.81
2020,1,1,14,27.91,11.11,43.62,92.45,2.19,120.96,2.67,120.99
2020,1,1,15,27.39,11.23,45.5,92.44,1.56,124.8,1.94,124.33
2020,1,1,16,26.56,12.08,51.38,92.48,0.8,116.82,1.11,116.21
2020,1,1,17,25.15,13.92,64.25,92.55,0.54,65.28,0.83,66.09
2020,1,1,18,23.84,15.01,74.94,92.64,0.88,43.57,1.49,45.0
2020,1,1,19,22.87,14.95,79.38,92.74,1.2,50.0,2.27,51.43
2020,1,1,20,22.16,14.59,80.62,92.82,1.45,54.68,2.97,55.6
2020,1,1,21,21.48,14.47,83.5,92.83,1.6,55.92,3.34,55.19
2020,1,1,22,20.93,14.47,86.38,92.8,1.7,56.46,3.44,55.37
2020,1,1,23,20.6,14.53,88.44,92.75,1.85,60.2,3.32,60.42
     */
    try {
      // linearResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
      //   'linearPredict',
      //   [14.53, 88.44, 92.75, 1.85, 60.2, 3.32, 60.42],
      // );
      // dnnResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
      //   'dnnPredict',
      //   [14.53, 88.44, 92.75, 1.85, 60.2, 3.32, 60.42],
      // );
      linearResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
        'linearPredict',
        [
          double.parse(controllers[0].text),
          double.parse(controllers[1].text),
          double.parse(controllers[2].text),
          double.parse(controllers[3].text),
          double.parse(controllers[4].text),
          double.parse(controllers[5].text),
          double.parse(controllers[6].text),
        ],
      );
      dnnResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
        'dnnPredict',
        [
          double.parse(controllers[0].text),
          double.parse(controllers[1].text),
          double.parse(controllers[2].text),
          double.parse(controllers[3].text),
          double.parse(controllers[4].text),
          double.parse(controllers[5].text),
          double.parse(controllers[6].text),
        ],
      );
      print(linearResult);
      print(dnnResult);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  final controllers = [
    TextEditingController(text: '14.53'),
    TextEditingController(text: '88.44'),
    TextEditingController(text: '92.75'),
    TextEditingController(text: '1.85'),
    TextEditingController(text: '60.2'),
    TextEditingController(text: '3.32'),
    TextEditingController(text: '60.42'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bengaluru',
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '13.3264, 77.1191',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              R.image.sunny,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
            ),
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  singleWeather(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: buildQuestionsView(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget singleWeather() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'TEMPERATURE\n${dnnResult == -1 ? '' : '${dnnResult.toInt()}° C'}',
            style: GoogleFonts.lato(
              fontSize: 45,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Text(
                                'Wind',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '23',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'km/h',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Text(
                                'Rain',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '50',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '%',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Text(
                                'Humidity',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '60',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '%',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuestionsView() {
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Specific Humidity',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[0],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Relative Humidity',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[1],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Surface Pressure',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[2],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Wind Speed(10m)',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[3],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Wind Direction(10m)',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[4],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Wind Speed(50m)',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[5],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFieldWidget(
                  borderColor: Colors.white60,
                  placeHolder: 'Wind Direction(50m)',
                  maxLength: 8,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  controller: controllers[6],
                  validator: (val) {
                    return val.isEmpty || val.length > 99
                        ? 'Enter a valid age'
                        : null;
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(top: 16),
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    'PREDICT',
                    style: TextStyle(
                      color: R.color.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    validateAndPredict();
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  void validateAndPredict() {
    if (controllers[0].text.isEmpty ||
        controllers[1].text.isEmpty ||
        controllers[2].text.isEmpty ||
        controllers[3].text.isEmpty ||
        controllers[4].text.isEmpty ||
        controllers[5].text.isEmpty ||
        controllers[6].text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a valid input');
      return;
    }
    getAnalysis();
  }
}
