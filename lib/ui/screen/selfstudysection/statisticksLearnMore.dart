import 'package:flutter/material.dart';

class StatisticsLearnMore extends StatefulWidget {
  @override
  _StatisticsLearnMoreState createState() => _StatisticsLearnMoreState();
}

class _StatisticsLearnMoreState extends State<StatisticsLearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help Menu3"),
      ),
      body: Container(
        child: Text("Some Text!!!"),
      ),
    );
  }
}
