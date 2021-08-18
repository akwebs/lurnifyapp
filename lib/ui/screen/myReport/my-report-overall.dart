import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyReportOverAll extends StatefulWidget {
  @override
  _MyReportOverAllState createState() => _MyReportOverAllState();
}

class _MyReportOverAllState extends State<MyReportOverAll> {
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
                                  '34th Day of 240 Days',
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
                                            Text(
                                              '280',
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
                                              '6:40',
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
                                    '20%',
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
                                percent: 0.20,
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
                                    '15%',
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
                                percent: 0.15,
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
                                    '20',
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
                                          '8',
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
                                        'Exellent',
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
                                          '7',
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
                                          '6',
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
                                          '2',
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
                                    '52%',
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
                                percent: 0.52,
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
      ),
    );
  }
}
