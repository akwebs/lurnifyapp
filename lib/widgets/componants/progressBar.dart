import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
    @required this.progressValue,
    @required this.taskText,
  }) : super(key: key);

  final double progressValue;
  final String taskText;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              positionFactor: 0.2,
              angle: 90,
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    progressValue.toStringAsFixed(0) + '%',
                    style: TextStyle(
                      fontSize: 35,
                      color: firstColor,
                    ),
                  ),
                  Text(
                    taskText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ))
        ],
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        axisLineStyle: AxisLineStyle(
          thickness: 0.2,
          cornerStyle: CornerStyle.bothCurve,
          color: Color.fromARGB(30, 81, 18, 129),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
              value: progressValue,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
              gradient: const SweepGradient(
                  colors: <Color>[Colors.purpleAccent, Colors.blueAccent],
                  stops: <double>[0.25, 0.75])),
          MarkerPointer(
            value: progressValue,
            markerType: MarkerType.circle,
            color: const Color(0xFFFF5252),
          )
        ],
      )
    ]);
  }
}
