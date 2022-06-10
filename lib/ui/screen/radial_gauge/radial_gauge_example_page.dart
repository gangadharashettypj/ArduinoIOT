import 'package:arduinoiot/ui/screen/radial_gauge/data/gauge_axis.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/data/gauge_axis_transformer.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/data/gauge_label_provider.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/data/gauge_pointer.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/data/gauge_segment.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/pointers/rounded_triangle_pointer.dart';
import 'package:arduinoiot/ui/screen/radial_gauge/widgets/animated_radial_gauge.dart';
import 'package:flutter/material.dart';

class RadialGaugeExamplePage extends StatefulWidget {
  const RadialGaugeExamplePage({Key key}) : super(key: key);

  @override
  State<RadialGaugeExamplePage> createState() => _RadialGaugeExamplePageState();
}

class _RadialGaugeExamplePageState extends State<RadialGaugeExamplePage>
    with AutomaticKeepAliveClientMixin {
  double value = 65;
  final double _degree = 180;
  final double _thickness = 14;
  final double _spacing = 4;
  final double _fontSize = 18;
  final double _pointerSize = 16;

  final _segments = const <GaugeSegment>[
    GaugeSegment(
      from: 0,
      to: 33.3,
      color: Color(0xFF34C759),
    ),
    GaugeSegment(
      from: 33.3,
      to: 66.6,
      color: Color(0xFF34C759),
    ),
    GaugeSegment(
      from: 66.6,
      to: 100,
      color: Color(0xFFD9DEEB),
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFEFEFEF),
          ),
        ),
        width: 200,
        height: 200,
        child: AnimatedRadialGauge(
          builder: (context, _, value) => RadialGaugeLabel(
            style: TextStyle(
              color: const Color(0xFF002E5F),
              fontSize: _fontSize,
              fontWeight: FontWeight.bold,
            ),
            value: value,
          ),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.elasticOut,
          min: 0,
          max: 100,
          value: value,
          axis: GaugeAxis(
            degrees: _degree,
            pointer: RoundedTrianglePointer(
              size: _pointerSize,
              borderRadius: _pointerSize * 0.125,
              backgroundColor: const Color(0xFF002E5F),
              border: GaugePointerBorder(
                color: Colors.white,
                width: _pointerSize * 0.125,
              ),
            ),
            transformer: const GaugeAxisTransformer.colorFadeIn(
              interval: Interval(0.0, 0.3),
              background: Color(0xFFD9DEEB),
            ),
            style: GaugeAxisStyle(
              thickness: _thickness,
              segmentSpacing: _spacing,
              blendColors: false,
            ),
            segments: _segments,
          ),
        ),
      ),
    );
  }
}
