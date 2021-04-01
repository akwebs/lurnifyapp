import 'package:flutter/material.dart';

class GolasLearnMore extends StatefulWidget {
  @override
  _GolasLearnMoreState createState() => _GolasLearnMoreState();
}

class _GolasLearnMoreState extends State<GolasLearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help Menu4"),
      ),
      body: Container(
        child: Text("Some Text!!!"),
      ),
    );
  }
}
