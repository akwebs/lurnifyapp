import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/widgets/componants/progressBar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';

class DareToDo extends StatefulWidget {
  @override
  _DareToDoState createState() => _DareToDoState();
}

List _weekDailyData = [];

class _DareToDoState extends State<DareToDo> {
  // ignore: unused_field
  Map<String, dynamic> _tasksMonths = Map();
  // ignore: unused_field
  List _dailyTask = [];
  // ignore: unused_field
  List _weeklyTask = [];
  // ignore: unused_field
  List _montholyTask = [];
  double progressValue = 0;
  String taskText = '';
  int _completedWeeks = 0;
  Map<String, dynamic> _weekData = Map();
  List _dailyTaskList = [];
  String _dailyTaskDetail = "";
  int _totalStudyTime = 0,
      _totalTests = 0,
      _completedStudyTime = 0,
      _completedTests = 0;
  double _netPercent = 0;
  //week variables
  int _completedWeekTests = 0, _weekTotalTests = 0;
  int _totalStudyHourInWeek = 0, _totalStudyHour = 0;
  int _minimumStudyDaysInWeek = 0, _completedDays = 0;

  //Overall
  double _overallPercent = 0;

  _getDareToDuo() async {
    try {
      _weekData = Map();
      _dailyTaskList = [];
      _dailyTaskDetail = "";
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl + "getDareToDo?regSno=" + sp.getString("studentSno");
      print(url);
      var response = await http.post(Uri.encodeFull(url));
      Map<String, dynamic> map = jsonDecode(response.body);
      _completedWeeks = map['completedWeeks'];
      _weekData = jsonDecode(map['week']);
      _dailyTaskList = jsonDecode(map['daily']);

      _dailyTaskList.forEach((element) {
        if (element['taskType'] == "study") {
          String reward = "";
          if (element['certificate'] != 0) {
            reward =
                reward + element['certificate'].toString() + " certificate\n";
          }
          if (element['cash'] != 0) {
            reward = reward + element['cash'].toString() + " cash\n";
          }

          if (element['coins'] != 0) {
            reward = reward + element['coins'].toString() + " coins\n";
          }

          if (element['noOfRefferalCoupons'] != 0) {
            reward = reward +
                element['noOfRefferalCoupons'].toString() +
                " Referral Coupons\n";
          }
          _dailyTaskDetail = _dailyTaskDetail +
              "You need to study for " +
              element['taskUnit'].toString() +
              " minutes to complete daily challenge. And reward will be " +
              reward +
              "\n";
          _totalStudyTime = _totalStudyTime + element['taskUnit'];
        }
        if (element['taskType'] == "test") {
          String reward = "";
          if (element['certificate'] != 0) {
            reward =
                reward + element['certificate'].toString() + " certificate\n";
          }
          if (element['cash'] != 0) {
            reward = reward + element['cash'].toString() + " cash\n";
          }

          if (element['coins'] != 0) {
            reward = reward + element['coins'].toString() + " coins\n";
          }

          if (element['noOfRefferalCoupons'] != 0) {
            reward = reward +
                element['noOfRefferalCoupons'].toString() +
                " Referral Coupons\n";
          }
          _dailyTaskDetail = _dailyTaskDetail +
              "You need to pass " +
              element['taskUnit'].toString() +
              " tests to complete daily challenge. And reward will be " +
              reward +
              "\n";
          _totalTests = _totalTests + element['taskUnit'];
        }
        if (element['totalStudy'] != null) {
          _completedStudyTime = _completedStudyTime + element['totalStudy'];
        }
        if (element['totalTest'] != null) {
          _completedTests = _completedTests + element['totalTest'];
        }
      });
      double percentStudyTime = _completedStudyTime / _totalStudyTime;
      double percentTest = _completedTests / _totalTests;

      _netPercent = (percentStudyTime + percentTest) / 2;

      // week data calculation
      if (_weekData['completedTest'] != null) {
        _completedWeekTests = _weekData['completedTest'];
      }

      if (_weekData['totalNumberOfTest'] != null) {
        _weekTotalTests = _weekData['totalNumberOfTest'];
      }

      if (_weekData['totalStudyHourInWeek'] != null) {
        _totalStudyHourInWeek = _weekData['totalStudyHourInWeek'];
      }

      if (_weekData['totalStudyHour'] != null) {
        _totalStudyHour = _weekData['totalStudyHour'];
      }

      if (_weekData['minimumStudyDays'] != null) {
        _minimumStudyDaysInWeek = _weekData['minimumStudyDays'];
      }

      if (_weekData['completedDailyStudy'] != null) {
        _completedDays = _weekData['completedDailyStudy'];
      }

      _overallPercent = ((_completedWeekTests / _weekTotalTests) +
              (_totalStudyHour / _totalStudyHourInWeek) +
              (_completedDays / _minimumStudyDaysInWeek)) *
          100 /
          3;
      Fluttertoast.showToast(
          msg: "Week k liye coins ki ui banani hai. data ye rha" +
              _weekData['coins'].toString());

      // print(_completedWeekTests);
      //Week Daily Data
      _weekDailyData = json.decode(map['weekDailyData']);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDareToDuo(),
        builder: (context, snapshot) {
          return DefaultTabController(
            // initialIndex: 1,
            length: 3,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Container(
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text("Dare To Do"),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child:
                                // _weekData['coins'] != null
                                // ?
                                Row(
                          children: [
                            Text(
                              // _weekData['coins'].toString(),
                              '150',
                              style: TextStyle(
                                  color: firstColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.monetization_on_rounded,
                              size: 18,
                            )
                          ],
                        )
                            // : Container()
                            ),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.deepPurpleAccent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.deepPurpleAccent,
                                Colors.deepPurple
                              ]),
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan[200].withOpacity(0.1),
                        Colors.purple[200].withOpacity(0.1)
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  children: <Widget>[
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AspectRatio(
                          aspectRatio: 4.5 / 2.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: ProgressBar(
                                    taskText: 'Daily Tasks',
                                    progressValue:
                                        _netPercent.isNaN ? 0 : _netPercent,
                                    taskText1: 'Overall Completed'),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyan[200].withOpacity(0.1),
                                      Colors.purple[200].withOpacity(0.1)
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _DailyTaskInfo(
                          dailyTaskDetail: _dailyTaskDetail == ''
                              ? 'Please Spin the Spinner to Get Daily Task'
                              : _dailyTaskDetail,
                        ),
                        Spacer(),
                        _WeekDays(),
                      ],
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            elevation: 0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 3.0 / 1.4,
                                    child: ProgressBar(
                                        taskText: 'Weekly Tasks',
                                        progressValue: _overallPercent.isNaN
                                            ? 0
                                            : _overallPercent,
                                        taskText1: 'Overall Completed'),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 7 / 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: _ProgressBar(
                                            progressValue: _completedWeekTests *
                                                100 /
                                                _weekTotalTests,
                                            x: _completedWeekTests.toString(),
                                            y: _weekTotalTests.toString(),
                                            taskText: 'TEST',
                                          ),
                                        ),
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: _ProgressBar(
                                              progressValue: _totalStudyHour *
                                                  100 /
                                                  _totalStudyHourInWeek,
                                              x: _totalStudyHour.toString(),
                                              y: _totalStudyHourInWeek
                                                  .toString(),
                                              taskText: 'HOURS'),
                                        ),
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: _ProgressBar(
                                              progressValue: _completedDays *
                                                  100 /
                                                  _minimumStudyDaysInWeek,
                                              x: _completedDays.toString(),
                                              y: _minimumStudyDaysInWeek
                                                  .toString(),
                                              taskText: 'DAYS'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan[200].withOpacity(0.1),
                                    Colors.purple[200].withOpacity(0.1)
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                              ),
                            ),
                          ),
                          //BarChartSample1(),
                          _WeekTaskInfo(),
                          _Weeks(),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 2.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.limeAccent[200]
                                                .withOpacity(0.1),
                                            Colors.teal[200].withOpacity(0.1)
                                          ],
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Complted Weeks',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            _completedWeeks.toString() +
                                                '/' +
                                                '4',
                                            style: TextStyle(
                                                color: firstColor,
                                                fontSize: 50),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: LinearPercentIndicator(
                                              padding: EdgeInsets.all(3),
                                              lineHeight: 10,
                                              percent:
                                                  ((_completedDays * 10) / 4) /
                                                      10,
                                              backgroundColor: Colors.deepPurple
                                                  .withOpacity(0.4),
                                              progressColor:
                                                  Colors.deepPurpleAccent,
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
                          AspectRatio(
                            aspectRatio: 3 / 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlue[200]
                                                    .withOpacity(0.1)
                                                // gradient: LinearGradient(
                                                //   colors: [
                                                //     Colors.cyan[200]
                                                //         .withOpacity(0.2),
                                                //     Colors.purple[200]
                                                //         .withOpacity(0.2)
                                                //   ],
                                                //   begin: Alignment.topRight,
                                                //   end: Alignment.bottomLeft,
                                                // ),
                                                ),
                                          ),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Total Test',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  _totalTests.toString(),
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlue[200]
                                                    .withOpacity(0.1)
                                                // gradient: LinearGradient(
                                                //   colors: [
                                                //     Colors.lightBlue[200]
                                                //         .withOpacity(0.2),
                                                //     Colors.lightGreen[200]
                                                //         .withOpacity(0.2)
                                                //   ],
                                                //   begin: Alignment.topRight,
                                                //   end: Alignment.bottomLeft,
                                                // ),
                                                ),
                                          ),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Study Hours',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  _completedStudyTime
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 24),
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple[200].withOpacity(0.2),
                      Colors.lightBlue[200].withOpacity(0.1)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar(
      {Key key,
      @required this.progressValue,
      @required this.taskText,
      this.x,
      this.y})
      : super(key: key);

  final double progressValue;
  final String taskText, x, y;

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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        progressValue.isNaN ? '0' : x + '/' + y,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        x == null && y == null ? '%' : '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    taskText,
                    style: TextStyle(
                      fontSize: 12,
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
          color: Color.fromARGB(30, 128, 112, 254),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
              value: progressValue.isNaN ? 0 : progressValue,
              width: 0.1,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
              gradient: const SweepGradient(
                  colors: <Color>[Colors.deepPurpleAccent, Colors.deepPurple],
                  stops: <double>[0.25, 0.75])),
          MarkerPointer(
            markerHeight: 5,
            markerWidth: 5,
            value: progressValue.isNaN ? 0 : progressValue,
            markerType: MarkerType.circle,
            color: Colors.deepPurple,
          )
        ],
      )
    ]);
  }
}

class _WeekDays extends StatelessWidget {
  const _WeekDays({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String isToday = DateFormat('d').format(DateTime.now());
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
                opacity: 1,
                child: Container(
                  decoration: BoxDecoration(
                    //color: AppColors.tileColors[1],
                    image: DecorationImage(
                        image: AssetImage('assets/bg/1-blue-bg.png'),
                        fit: BoxFit.cover),
                  ),
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
                      String date = DateFormat('d').format(DateTime.now()
                          .subtract(Duration(days: DateTime.now().weekday - 1))
                          .add(Duration(days: i)));
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            clipBehavior: Clip.antiAlias,
                            color: AppColors.tileColors[i],
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppSlider.weekDays[i],
                                      style: (isToday == date)
                                          ? TextStyle(
                                              fontSize: 12,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold)
                                          : TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      date,
                                      style: (isToday == date)
                                          ? TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            )
                                          : TextStyle(),
                                    ),
                                  ],
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

class _Weeks extends StatelessWidget {
  const _Weeks({
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
                opacity: 1,
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
                    itemCount: 4,
                    shrinkWrap: true,
                    primary: false,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            clipBehavior: Clip.antiAlias,
                            color: AppColors.tileColors[i],
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Center(
                                child: Text(
                                  AppSlider.weeks[i],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
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

class _DailyTaskInfo extends StatelessWidget {
  final String dailyTaskDetail;
  const _DailyTaskInfo({Key key, this.dailyTaskDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.0 / 2.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  dailyTaskDetail,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple[200].withOpacity(0.1),
                  Colors.cyan[200].withOpacity(0.1)
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekTaskInfo extends StatelessWidget {
  const _WeekTaskInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.0 / 2.8,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.only(top: 30.0),
            child: AspectRatio(
              aspectRatio: 4.0 / 2.4,
              child: _BarChartNew(),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan[200].withOpacity(0.1),
                  Colors.purple[200].withOpacity(0.1)
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarChartNew extends StatelessWidget {
  const _BarChartNew({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            // tooltipMargin: 8,
            tooltipBottomMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.round() == 0 ? '' : rod.y.round().toString(),
                TextStyle(
                  color: rod.y.round() >= 5 ? Colors.green : Colors.redAccent,
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
            getTextStyles: (value) => TextStyle(
                color: isDark ? Colors.white : Colors.black87, fontSize: 14),
            margin: 5,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'Mon';
                case 1:
                  return 'Tue';
                case 2:
                  return 'Wed';
                case 3:
                  return 'Thu';
                case 4:
                  return 'Fri';
                case 5:
                  return 'Sat';
                case 6:
                  return 'Sun';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
                color: isDark ? Colors.white : Colors.black87, fontSize: 14),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: List.generate(7, (i) {
          double value = 0;
          String date = DateFormat('yyyy-MM-dd').format(DateTime.now()
              .subtract(Duration(days: DateTime.now().weekday - 1))
              .add(Duration(days: i)));
          _weekDailyData.forEach((element) {
            if (element['date'] == date) {
              value = element['totalHour'].toDouble();
            }
          });
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                y: value,
                colors: [
                  (value >= 5) ? Colors.green : Colors.green.withOpacity(0.6),
                ],
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  y: 10,
                  colors: [Colors.deepPurple.withOpacity(0.2)],
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
      ),
    );
  }
}
