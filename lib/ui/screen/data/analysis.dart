/*
 * @Author GS
 */

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/radial_gauge.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AnalysisScreenMain extends StatefulWidget {
  const AnalysisScreenMain({Key key}) : super(key: key);

  @override
  State<AnalysisScreenMain> createState() => _AnalysisScreenMainState();
}

class _AnalysisScreenMainState extends State<AnalysisScreenMain> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return AnalysisScreen(
      bpm: args['bpm'],
      ecg: args['ecg'],
      gsr: args['gsr'],
      gsrc: args['gsrc'],
      result: args['result'],
      stressScore: args['stressScore'],
      actualDnnResult: args['actualDnnResult'],
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  String ecg;
  String bpm;
  String gsr;
  String gsrc;
  double result;
  double actualDnnResult;
  int stressScore;

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();

  AnalysisScreen({
    this.ecg = '0',
    this.bpm = '0',
    this.gsr = '0',
    this.gsrc = '0',
    this.result = -1,
    this.actualDnnResult = -1,
    this.stressScore = -1,
  });
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: R.color.primary,
        title: Text(
          'Live Device Data',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Reconnect',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Response res = await HttpREST().get(
                R.api.setClientIP,
                params: {
                  'ip': 'sd',
                  'port': '2345',
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'Stress Q&A: ${widget.stressScore == -1 ? '' : widget.stressScore}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'Sensors Stress: ${widget.actualDnnResult.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (widget.result != -1)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 200,
                child: AnimatedRadialGauge(
                  builder: (context, _, value) => RadialGaugeLabel(
                    style: TextStyle(
                      color: const Color(0xFF002E5F),
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                    value: value,
                  ),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.elasticOut,
                  min: 0,
                  max: 100,
                  value: widget.result,
                  axis: GaugeAxis(
                    degrees: 260,
                    pointer: RoundedTrianglePointer(
                      size: 16,
                      borderRadius: 16 * 0.125,
                      backgroundColor: const Color(0xFF002E5F),
                      border: GaugePointerBorder(
                        color: Colors.white,
                        width: 16 * 0.125,
                      ),
                    ),
                    transformer: const GaugeAxisTransformer.colorFadeIn(
                      interval: Interval(0.0, 0.3),
                      background: Color(0xFFD9DEEB),
                    ),
                    style: GaugeAxisStyle(
                      thickness: 14,
                      segmentSpacing: 4,
                      blendColors: false,
                    ),
                    segments: [
                      GaugeSegment(
                        from: 0,
                        to: 33.3,
                        color: Colors.green,
                      ),
                      GaugeSegment(
                        from: 33.3,
                        to: 66.6,
                        color: Colors.orange,
                      ),
                      GaugeSegment(
                        from: 66.6,
                        to: 100,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.result != -1)
              Center(
                child: Text(
                  'Total Stress Score',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            SizedBox(
              height: 60,
            ),
            RaisedButton(
              color: R.color.primary,
              child: Text(
                'Get Recommendation',
                style: TextStyle(
                  color: R.color.opposite,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  R.routes.recommendation,
                  arguments: widget.result < 33
                      ? R.image.normal
                      : (widget.result < 67 ? R.image.moderate : R.image.high),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
