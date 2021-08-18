import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyReportOverAll extends StatefulWidget {
  final int i;
  final List _subjectList;
  MyReportOverAll(this._subjectList,this.i);
  @override
  _MyReportOverAllState createState() => _MyReportOverAllState(_subjectList,i);
}

class _MyReportOverAllState extends State<MyReportOverAll> {
  final int i;
  final List _subjectList;
  _MyReportOverAllState(this._subjectList,this.i);
  int _completedDays=0;
  int _totalDays=0;
  double _totalSubjectStudyInHour=0;
  double _avgStudyHour=0;
  double _preparationTimePassed=0;
  double _syllabusCompleted=0;
  int _failedTest=0;
  int _avgTest=0;
  int _goodTest=0;
  int _exTest=0;
  int _totalTopicTest=0;
  double _testPercent=0;
  double _totalCompletedTopicMinutes=0;
  double _totalTopicDurationInMinute=0;

  @override
  void initState() {
    if(i==-1){
      int t1=0;
      int fTest=0,aTest=0,gTest=0,eTest=0;
      double tPercent=0,totalCompletedTopicMinutes=0,totalTopicDurationInMinute=0;
      for(var a in _subjectList){
        _completedDays=a['totalCompletedDays'].round() ?? 0;
        if(_completedDays<0){
          _completedDays=0;
        }
        _totalDays=a['totalCourseDays'].round() ?? 0;

        totalCompletedTopicMinutes=totalCompletedTopicMinutes+(a['totalCompletedTopicMinutes']??0);
        totalTopicDurationInMinute=totalTopicDurationInMinute+(a['totalTopicDurationInMinute']??0);

        t1=t1+(a['totalSubjectStudyInSeconds']==null?0:a['totalSubjectStudyInSeconds']);
        fTest=fTest+a['failedTest'];
        aTest=aTest+a['avgTest'];
        gTest=gTest+a['goodTest'];
        eTest=eTest+a['excelentTest'];
        tPercent=tPercent+(a['testPercent']??0);
      }
      _totalCompletedTopicMinutes=totalCompletedTopicMinutes;
      _totalTopicDurationInMinute=totalTopicDurationInMinute;
      _testPercent=tPercent;
      _totalSubjectStudyInHour=t1/3600;
      _avgStudyHour=_totalSubjectStudyInHour/_totalDays;
      _syllabusCompleted=(_totalCompletedTopicMinutes/_totalTopicDurationInMinute);
      if(_syllabusCompleted.isNaN || _syllabusCompleted==null){
        _syllabusCompleted=0;
      }
      _failedTest=fTest;
      _avgTest=aTest;
      _goodTest=gTest;
      _exTest=eTest;
      _totalTopicTest=_failedTest+_avgTest+_goodTest+_exTest;
    }else{
      if(_subjectList.length-1>=i){
        _completedDays=_subjectList[i]['totalCompletedDays'].round() ?? 0;
        if(_completedDays<0){
          _completedDays=0;
        }
        _totalDays=_subjectList[i]['totalCourseDays'].round() ?? 0;
        _totalSubjectStudyInHour=_subjectList[i]['totalSubjectStudyInSeconds']==null?0:(_subjectList[i]['totalSubjectStudyInSeconds']/3600);
        _avgStudyHour=_totalSubjectStudyInHour/_totalDays;
        _totalCompletedTopicMinutes=_subjectList[i]['totalCompletedTopicMinutes'].toDouble()??0;
        _totalTopicDurationInMinute=_subjectList[i]['totalTopicDurationInMinute'].toDouble()??0;
        _syllabusCompleted=(_totalCompletedTopicMinutes/_totalTopicDurationInMinute);
        if(_syllabusCompleted.isNaN || _syllabusCompleted==null){
          _syllabusCompleted=0;
        }
        _failedTest=_subjectList[i]['failedTest'];
        _avgTest=_subjectList[i]['avgTest'];
        _goodTest=_subjectList[i]['goodTest'];
        _exTest=_subjectList[i]['excelentTest'];
        _totalTopicTest=_failedTest+_avgTest+_goodTest+_exTest;
        double testPercent=0;
        if(_subjectList[i]['testPercent']==null){
          testPercent=0;
        }else{
          testPercent=_subjectList[i]['testPercent'].toDouble();
        }
        _testPercent=testPercent ?? 0;
      }


    }
    _preparationTimePassed=(_completedDays/_totalDays);
    if(_preparationTimePassed==null || _preparationTimePassed.isNaN){
      _preparationTimePassed=0;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple[200].withOpacity(0.2),
                Colors.lightBlue[200].withOpacity(0.1)
              ],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Overall Study Report',
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 6,
                child: Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.red.withOpacity(0.3),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Progress Analysis',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${_completedDays}th Day of ${_totalDays}Days',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 90,
                                        lineWidth: 4.0,
                                        animation: true,
                                        percent: 1.0,
                                        center: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(_totalSubjectStudyInHour.toStringAsFixed(2),
                                              // _totalSubjectSeconds.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Hrs',
                                            ),
                                          ],
                                        ),
                                        backgroundColor:
                                        Color.fromARGB(30, 128, 112, 254),
                                        circularStrokeCap:
                                        CircularStrokeCap.round,
                                        progressColor: Colors.lightGreen,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Total Study Hours',
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 90,
                                        lineWidth: 4.0,
                                        animation: true,
                                        percent: 1.0,
                                        center: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _avgStudyHour.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Hrs',
                                            ),
                                          ],
                                        ),
                                        backgroundColor:
                                        Color.fromARGB(30, 128, 112, 254),
                                        circularStrokeCap:
                                        CircularStrokeCap.round,
                                        progressColor: Colors.lightGreen,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Avg Study Hrs/day',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Preparation time passes till Now',
                                  ),
                                  Spacer(),
                                  Text(
                                    _preparationTimePassed.toStringAsFixed(2)+'%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: LinearPercentIndicator(
                                lineHeight: 5,
                                percent: _preparationTimePassed,
                                backgroundColor: Colors.black.withOpacity(0.2),
                                progressColor: Colors.lightGreen,
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Syllabus completed till Date',
                                  ),
                                  Spacer(),
                                  Text(
                                    _syllabusCompleted.toStringAsFixed(2) +'%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: LinearPercentIndicator(
                                lineHeight: 5,
                                percent: _syllabusCompleted,
                                backgroundColor: Colors.black.withOpacity(0.2),
                                progressColor: Colors.redAccent,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 6,
                child: Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.lightBlue.withOpacity(0.3),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Topic Test Analysis',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Total Topic Test Attempted',
                                  ),
                                  Spacer(),
                                  Text(
                                    _totalTopicTest.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 40,
                                        lineWidth: 3.0,
                                        animation: true,
                                        percent: 1.0,
                                        center: Text(
                                          '$_exTest',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        backgroundColor:
                                        Color.fromARGB(30, 128, 112, 254),
                                        circularStrokeCap:
                                        CircularStrokeCap.round,
                                        progressColor: Colors.green,
                                      ),
                                      Text(
                                        'Excellent',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 40,
                                        lineWidth: 3.0,
                                        animation: true,
                                        percent: 1.0,
                                        center: Text(
                                          '$_goodTest',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        backgroundColor:
                                        Color.fromARGB(30, 128, 112, 254),
                                        circularStrokeCap:
                                        CircularStrokeCap.round,
                                        progressColor: Colors.orange,
                                      ),
                                      Text(
                                        'Good',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 40,
                                        lineWidth: 3.0,
                                        animation: true,
                                        percent: 1.0,
                                        center: Text(
                                          '$_avgTest',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        backgroundColor:
                                        Color.fromARGB(30, 128, 112, 254),
                                        circularStrokeCap:
                                        CircularStrokeCap.round,
                                        progressColor: Colors.red,
                                      ),
                                      Text(
                                        'Average',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 40,
                                        lineWidth: 3.0,
                                        animation: true,
                                        percent: 1.0,
                                        center: Text(
                                          '$_failedTest',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        backgroundColor:
                                        Color.fromARGB(30, 128, 112, 254),
                                        circularStrokeCap:
                                        CircularStrokeCap.round,
                                        progressColor: Colors.grey,
                                      ),
                                      Text(
                                        'Failed',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Overall Test Performance',
                                  ),
                                  Spacer(),
                                  Text(
                                    (_testPercent*100).toStringAsFixed(2)+'%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: LinearPercentIndicator(
                                lineHeight: 5,
                                percent: _testPercent,
                                backgroundColor: Colors.black.withOpacity(0.2),
                                progressColor: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class BarChartNew extends StatelessWidget {
  const BarChartNew({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.light;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            //tooltipMargin: 8,
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
                  color: rod.y.round() >= 5 ? Colors.white : Colors.white,
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
                  return 'Phy';
                case 1:
                  return 'Che';
                case 2:
                  return 'Math';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
            getTextStyles: (value) => TextStyle(
                color: isDark ? Colors.white : Colors.black87, fontSize: 14),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 5,
                colors: [whiteColor],
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                y: 3,
                colors: [whiteColor],
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                y: 9,
                colors: [whiteColor],
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        ],
      ),
    );
  }
}
