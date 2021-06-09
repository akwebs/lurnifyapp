import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/widgets/componants/bar-chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

class DareToDo extends StatefulWidget {
  @override
  _DareToDoState createState() => _DareToDoState();
}

class _DareToDoState extends State<DareToDo> {
  Map<String, dynamic> _tasksMonths = Map();
  List _dailyTask = [];
  List _weeklyTask = [];
  List _montholyTask = [];
  double progressValue = 0;
  String taskText = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Dare To Do"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                unselectedLabelColor: Colors.redAccent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.orangeAccent]),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.redAccent),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Daily",
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Weekly"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Monthly"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AspectRatio(
                      aspectRatio: 4.5 / 3.0,
                      child: _progressBar(
                          progressValue: 45, taskText: 'Daily task Completed')),
                  DailyTaskInfo(),
                  WeekDays(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AspectRatio(
                    aspectRatio: 3.0 / 1.4,
                    child: _progressBar(progressValue: 65, taskText: 'Overall'),
                  ),
                  AspectRatio(
                    aspectRatio: 6.5 / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child:
                              _progressBar(progressValue: 25, taskText: 'TEST'),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: _progressBar(
                              progressValue: 49, taskText: 'HOURS'),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child:
                              _progressBar(progressValue: 36, taskText: 'DAYS'),
                        ),
                      ],
                    ),
                  ),
                  //BarChartSample1(),
                  WeekTaskInfo(),
                  WeekDays(),
                ],
              ),
              Center(
                child: Text('Text with style'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _progressBar extends StatelessWidget {
  const _progressBar({
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
              positionFactor: 0.1,
              angle: 90,
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    progressValue.toStringAsFixed(0) + '%',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.redAccent,
                    ),
                  ),
                  Text(
                    taskText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orangeAccent,
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
          thickness: 0.1,
          cornerStyle: CornerStyle.bothCurve,
          color: Color.fromARGB(30, 251, 41, 7),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
              value: progressValue,
              width: 0.1,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
              gradient: const SweepGradient(
                  colors: <Color>[Colors.redAccent, Colors.orangeAccent],
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

class WeekDays extends StatelessWidget {
  const WeekDays({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7.0 / 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg/1-blue-bg.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemCount: 7,
                    shrinkWrap: true,
                    primary: false,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            color: AppColors.tileColors[i],
                            child: AspectRatio(
                              aspectRatio: 1.0 / 1.0,
                              child: Center(
                                child: Text(
                                  AppSlider.weekDays[i],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyTaskInfo extends StatelessWidget {
  const DailyTaskInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.0 / 2.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg/1-orrange-bg.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Details of task assigned and outcome reward like: coins, referral coupon,cash coupons, trophy with its type',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeekTaskInfo extends StatelessWidget {
  const WeekTaskInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.0 / 2.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg/1-orrange-bg.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.7,
                child: BarChartNew(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarChartNew extends StatelessWidget {
  const BarChartNew({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(5),
            tooltipMargin: 8,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 20,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'Mn';
                case 1:
                  return 'Tu';
                case 2:
                  return 'Wd';
                case 3:
                  return 'Th';
                case 4:
                  return 'Fr';
                case 5:
                  return 'St';
                case 6:
                  return 'Sn';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                  y: 8, colors: [Colors.redAccent, Colors.orangeAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                  y: 14, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  y: 15, colors: [Colors.purpleAccent, Colors.blueAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  y: 13, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  y: 10, colors: [Colors.yellowAccent, Colors.orangeAccent])
            ],
            showingTooltipIndicators: [0],
          ),
        ],
      ),
    );
  }
}
