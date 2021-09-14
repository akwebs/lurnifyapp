import 'package:flutter/material.dart';

class GolasLearnMore extends StatefulWidget {
  const GolasLearnMore({Key key}) : super(key: key);

  @override
  _GolasLearnMoreState createState() => _GolasLearnMoreState();
}

class _GolasLearnMoreState extends State<GolasLearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Menu4"),
      ),
      body: const Center(child: Text("Some Text!!!")),
    );
  }
}

class StartSelfStudyLearnMore extends StatefulWidget {
  const StartSelfStudyLearnMore({Key key}) : super(key: key);

  @override
  _StartSelfStudyLearnMoreState createState() => _StartSelfStudyLearnMoreState();
}

class _StartSelfStudyLearnMoreState extends State<StartSelfStudyLearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Menu"),
      ),
      body: const Center(child: Text("Some Text!!!")),
    );
  }
}

class StatisticsLearnMore extends StatefulWidget {
  const StatisticsLearnMore({Key key}) : super(key: key);

  @override
  _StatisticsLearnMoreState createState() => _StatisticsLearnMoreState();
}

class _StatisticsLearnMoreState extends State<StatisticsLearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Menu3"),
      ),
      body: const Center(child: Text("Some Text!!!")),
    );
  }
}

class SyncStudyTimeLearnMore extends StatefulWidget {
  const SyncStudyTimeLearnMore({Key key}) : super(key: key);

  @override
  _SyncStudyTimeLearnMoreState createState() => _SyncStudyTimeLearnMoreState();
}

class _SyncStudyTimeLearnMoreState extends State<SyncStudyTimeLearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Menu2"),
      ),
      body: const Center(child: Text("Some Text!!!")),
    );
  }
}
