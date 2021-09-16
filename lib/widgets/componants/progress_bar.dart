import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {Key key,
      @required this.progressValue,
      this.taskText,
      this.taskText1,
      this.radius})
      : super(key: key);

  final double progressValue;
  final String taskText;
  final String taskText1;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskText == null ? '' : taskText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                taskText1 == null ? '' : taskText1,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: CircularPercentIndicator(
              radius: radius == null ? 140 : radius,
              lineWidth: 10.0,
              animation: true,
              percent: progressValue / 100,
              center: Text(
                progressValue.toStringAsFixed(0) + "%",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Color.fromARGB(30, 128, 112, 254),
              circularStrokeCap: CircularStrokeCap.round,
              linearGradient: LinearGradient(
                  colors: <Color>[Colors.deepPurpleAccent, Colors.deepPurple],
                  stops: <double>[0.25, 0.75])),
        ),
      ],
    );
  }
}
