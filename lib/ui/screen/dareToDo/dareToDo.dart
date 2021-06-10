import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../constant/ApiConstant.dart';

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
  int _completedWeeks=0;
  Map<String,dynamic> _weekData=Map();
  List _dailyTaskList=[];
  String _dailyTaskDetail="";
  int _totalStudyTime=0,_totalTests=0,_completedStudyTime=0,_completedTests=0;
  double _netPercent=0;
  //week variables
  int _completedWeekTests=0,_weekTotalTests=0;
  int _totalStudyHourInWeek=0,_totalStudyHour=0;
  int _minimumStudyDaysInWeek=0,_completedDays=0;

  //Overall
  double _overallPercent=0;


  _getDareToDuo()async{
   try{
     _weekData=Map();
     _dailyTaskList=[];
     _dailyTaskDetail="";
     SharedPreferences sp = await SharedPreferences.getInstance();
     var url=baseUrl+"getDareToDo?regSno="+sp.getString("studentSno");
     print(url);
     var response = await http.post(Uri.encodeFull(url));
     Map<String,dynamic> map = jsonDecode(response.body);
     _completedWeeks=map['completedWeeks'];
     _weekData=jsonDecode(map['week']);
     _dailyTaskList=jsonDecode(map['daily']);

     _dailyTaskList.forEach((element) {
       if(element['taskType']=="study"){
         String reward="";
         if(element['certificate']!=0){
           reward=reward+element['certificate'].toString()+" certificate\n";
         }
         if(element['cash']!=0){
           reward=reward+element['cash'].toString()+" cash\n";
         }

         if(element['coins']!=0){
           reward=reward+element['coins'].toString()+" coins\n";
         }

         if(element['noOfRefferalCoupons']!=0){
           reward=reward+element['noOfRefferalCoupons'].toString()+" Referral Coupons\n";
         }
         _dailyTaskDetail=_dailyTaskDetail+"You need to study for "+element['taskUnit'].toString() +" minutes to complete daily challenge. And reward will be "+reward+"\n";
         _totalStudyTime=_totalStudyTime+element['taskUnit'];
       }
       if(element['taskType']=="test"){
         String reward="";
         if(element['certificate']!=0){
           reward=reward+element['certificate'].toString()+" certificate\n";
         }
         if(element['cash']!=0){
           reward=reward+element['cash'].toString()+" cash\n";
         }

         if(element['coins']!=0){
           reward=reward+element['coins'].toString()+" coins\n";
         }

         if(element['noOfRefferalCoupons']!=0){
           reward=reward+element['noOfRefferalCoupons'].toString()+" Referral Coupons\n";
         }
         _dailyTaskDetail=_dailyTaskDetail+"You need to pass "+element['taskUnit'].toString() +" tests to complete daily challenge. And reward will be "+reward+"\n";
         _totalTests=_totalTests+element['taskUnit'];
       }
       if(element['totalStudy']!=null){
         _completedStudyTime=_completedStudyTime+element['totalStudy'];
       }
       if(element['totalTest']!=null){
         _completedTests=_completedTests+element['totalTest'];
       }

     });
     double percentStudyTime=_completedStudyTime/_totalStudyTime;
     double percentTest=_completedTests/_totalTests;

     _netPercent=(percentStudyTime+percentTest)/2;

     // week data calculation
     if(_weekData['completedTest']!=null){
       _completedWeekTests=_weekData['completedTest'];
     }

     if(_weekData['totalNumberOfTest']!=null){
       _weekTotalTests=_weekData['totalNumberOfTest'];
     }

     if(_weekData['totalStudyHourInWeek']!=null){
       _totalStudyHourInWeek=_weekData['totalStudyHourInWeek'];
     }

     if(_weekData['totalStudyHour']!=null){
       _totalStudyHour=_weekData['totalStudyHour'];
     }

     if(_weekData['minimumStudyDays']!=null){
        _minimumStudyDaysInWeek=_weekData['minimumStudyDays'];
     }

     if(_weekData['completedDailyStudy']!=null){
        _completedDays=_weekData['completedDailyStudy'];
     }

     _overallPercent=((_completedWeekTests/_weekTotalTests)+(_totalStudyHour/_totalStudyHourInWeek)+(_completedDays/_minimumStudyDaysInWeek))*100/3;
      Fluttertoast.showToast(msg: "Week k liye coins ki ui banani hai. data ye rha"+_weekData['coins'].toString());
   }catch(e){
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
                          child: ProgressBar(
                              progressValue: _netPercent, taskText: 'Daily task Completed')),
                      DailyTaskInfo(dailyTaskDetail: _dailyTaskDetail,),
                      WeekDays(),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AspectRatio(
                        aspectRatio: 3.0 / 1.4,
                        child: ProgressBar(progressValue: _overallPercent, taskText: 'Overall'),
                      ),
                      AspectRatio(
                        aspectRatio: 6.5 / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child:
                              ProgressBar(progressValue: _completedWeekTests*100/_weekTotalTests, taskText: 'TEST'),
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: ProgressBar(
                                  progressValue: _totalStudyHour*100/_totalStudyHourInWeek, taskText: 'HOURS'),
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child:
                              ProgressBar(progressValue: _completedDays*100/_minimumStudyDaysInWeek, taskText: 'DAYS'),
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
    );
  }
}

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
                      String date=DateFormat('d').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday-1)).add(Duration(days: i)));
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
                                  AppSlider.weekDays[i]+" "+date,
                                  style: TextStyle(
                                      fontSize: 15,color: Colors.black45,
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
  final String dailyTaskDetail;
  const DailyTaskInfo({
    Key key,
    this.dailyTaskDetail
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
                    dailyTaskDetail,
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
            // tooltipMargin: 8,
            tooltipBottomMargin: 8,
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
