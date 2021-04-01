import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

// ignore: camel_case_types
class marQuee extends StatelessWidget {
  final String _marqueeText;
  marQuee(this._marqueeText);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Marquee(
        text: utf8.decode(_marqueeText.runes.toList()),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 20.0,
        velocity: 50.0,
        pauseAfterRound: Duration(seconds: 1),
        startPadding: 10.0,
        accelerationDuration: Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }
}
