import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myProgress/UnitProgress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyProgress extends StatefulWidget {
  @override
  _MyProgressState createState() => _MyProgressState();
}

Color _backgroundColor = AppColors.tileIconColors[3];

class _MyProgressState extends State<MyProgress> {
  List _mySubjectProgress;
  Future _getMySubjectProgress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String registrationSno = sp.getString("studentSno");
    String courseSno = sp.getString("courseSno");
    var url = baseUrl +
        "getSubjectProgressByCourse?registrationSno=" +
        registrationSno +
        "&courseSno=" +
        courseSno;
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    _mySubjectProgress = resbody;
    print(_mySubjectProgress);
  }

  @override
  void initState() {
    _mySubjectProgress = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMySubjectProgress(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return DefaultTabController(
            // initialIndex: 1,
            length: 3,
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                    top: -Responsive.getPercent(
                        100, ResponsiveSize.HEIGHT, context),
                    left: -Responsive.getPercent(
                        50, ResponsiveSize.WIDTH, context),
                    right: -Responsive.getPercent(
                        40, ResponsiveSize.WIDTH, context),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 50,
                            spreadRadius: 2,
                            offset: Offset(20, 0)),
                        BoxShadow(
                            color: Colors.white12,
                            blurRadius: 0,
                            spreadRadius: -2,
                            offset: Offset(0, 0)),
                      ], shape: BoxShape.circle, color: _backgroundColor),
                    ),
                  ),
                  Container(
                    height: Responsive.getPercent(
                        35, ResponsiveSize.HEIGHT, context),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            top: 50,
                            left: 150,
                            right: -100,
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 50,
                                        spreadRadius: 2,
                                        offset: Offset(20, 0)),
                                    BoxShadow(
                                        color: Colors.white12,
                                        blurRadius: 0,
                                        spreadRadius: -2,
                                        offset: Offset(0, 0)),
                                  ],
                                  shape: BoxShape.circle,
                                  color: _backgroundColor.withOpacity(0.2)),
                            ),
                          ),
                          Positioned.fill(
                            top: 50,
                            bottom: 50,
                            left: -300,
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 50,
                                        spreadRadius: 1,
                                        offset: Offset(20, 0)),
                                    BoxShadow(
                                        color: Colors.white12,
                                        blurRadius: 0,
                                        spreadRadius: -2,
                                        offset: Offset(0, 0)),
                                  ],
                                  shape: BoxShape.circle,
                                  color: _backgroundColor.withOpacity(0.2)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Stack(
                      children: [
                        PreferredSize(
                          preferredSize: Size.fromHeight(70),
                          child: Container(
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              title: Text('Progress'),
                              centerTitle: true,
                            ),
                            // decoration: BoxDecoration(
                            //   gradient: LinearGradient(
                            //     colors: [Colors.amber, Colors.yellow],
                            //     begin: Alignment.topRight,
                            //     end: Alignment.bottomLeft,
                            //   ),
                            // ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 90),
                          child: TabBarView(
                            children:
                                List.generate(_mySubjectProgress.length, (i) {
                              return SingleChildScrollView(
                                child: ListView.builder(
                                  itemCount: _mySubjectProgress.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, i) {
                                    double subjectPercent =
                                        (_mySubjectProgress[i]
                                                ['userCompletedTopics'] /
                                            _mySubjectProgress[i]
                                                ['totalTopics'] *
                                            100);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 8, left: 8),
                                      child: AspectRatio(
                                        aspectRatio: 4 / 1,
                                        child: InkWell(
                                          onTap: () {
                                            _getUnits(
                                                _mySubjectProgress[i]
                                                    ['subjectSno'],
                                                _mySubjectProgress[i]
                                                    ['subjectName']);
                                          },
                                          child: Card(
                                            margin: EdgeInsets.only(bottom: 8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Image.asset(
                                                      AppSlider.cardimage[i],
                                                      fit: BoxFit.contain,
                                                      height: 50,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      _mySubjectProgress[i]
                                                          ['subjectName'],
                                                      style: TextStyle(
                                                          color: whiteColor),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 50,
                                                      lineWidth: 5.0,
                                                      animation: true,
                                                      percent:
                                                          subjectPercent / 100,
                                                      center: Text(
                                                        subjectPercent
                                                                .toStringAsFixed(
                                                                    0) +
                                                            "%",
                                                        style: TextStyle(
                                                          color: whiteColor,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Color.fromARGB(30,
                                                              255, 255, 255),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      progressColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                gradient:
                                                    AppSlider.sliderGradient[i],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.deepPurpleAccent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: AppSlider.gradient[0],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    tabs: List.generate(_mySubjectProgress.length, (i) {
                      return new Tab(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LinearPercentIndicator(
                              padding: EdgeInsets.all(3),
                              lineHeight: 5,
                              percent: _mySubjectProgress[i]
                                      ['userCompletedTopics'] /
                                  _mySubjectProgress[i]['totalTopics'],
                              backgroundColor: Colors.white.withOpacity(0.4),
                              progressColor: Colors.deepPurpleAccent,
                            ),
                            Text(
                              _mySubjectProgress[i]['subjectName'],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  _getUnits(sno, sname) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UnitProgress(sno, sname),
    ));
  }
}


// ListView.builder(
// itemCount: _mySubjectProgress.length,
// shrinkWrap: true,
// primary: false,
// itemBuilder: (context, i) {
//   double subjectPercent = (_mySubjectProgress[i]
//           ['userCompletedTopics'] /
//       _mySubjectProgress[i]['totalTopics'] *
//       100);
//   return GestureDetector(
//       onTap: () {
//         _getUnits(_mySubjectProgress[i]['subjectSno']);
//       },
//       child: Text(_mySubjectProgress[i]['subjectName']));
// },
// ),


//Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Card(
//     elevation: 0,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10)),
//     clipBehavior: Clip.antiAlias,
//     child: Padding(
//       padding: EdgeInsets.all(10),
//       child: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: 4 / 2,
//             child: ProgressBar(
//                 taskText1: 'Anil',
//                 progressValue: _mySubjectProgress[i]
//                         ['userCompletedTopics'] /
//                     _mySubjectProgress[i]['totalTopics'],
//                 taskText: _mySubjectProgress[i]
//                     ['subjectName']),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             "Total Completed " +
//                 _mySubjectProgress[i]['subjectName'] +
//                 "%.",
//             style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.w800),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(5)),
//               child: Text(
//                 "Click here for more detail",
//                 style: TextStyle(color: Colors.white),
//               ))
//         ],
//       ),
//     ),
//   ),
// ),