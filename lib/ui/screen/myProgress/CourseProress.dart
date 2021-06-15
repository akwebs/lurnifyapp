import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myProgress/SubjectProgress.dart';
import 'package:lurnify/widgets/componants/progressBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CourseProgress extends StatefulWidget {
  @override
  _CourseProgressState createState() => _CourseProgressState();
}

class _CourseProgressState extends State<CourseProgress> {
  int userCompletedTopics = 0, totalTopics = 0;
  double _coursePercent = 0;
  Future _getMyCourseProgress() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String registrationSno = sp.getString("studentSno");
      String courseSno = sp.getString("courseSno");
      var url = baseUrl +
          "getProgressByCourse?registrationSno=" +
          registrationSno +
          "&courseSno=" +
          courseSno;
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      Map<String, dynamic> myProgress = resbody;
      totalTopics = myProgress['totalTopics'];
      userCompletedTopics = myProgress['userCompletedTopics'];
      _coursePercent = (userCompletedTopics / totalTopics);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("My Course Progress"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: _getMyCourseProgress(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AspectRatio(
                                  aspectRatio: 4.0 / 2.2,
                                  child: Container(
                                    child: ProgressBar(
                                      progressValue: _coursePercent,
                                      taskText: 'Course',
                                      taskText1: 'Overall',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Card(
                                  child: TextButton(
                                    onPressed: () {
                                      _getSubjects();
                                    },
                                    child: Text('Click here for more detail'),
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.lightBlue[100].withOpacity(0.1),
                                  Colors.deepPurple[100].withOpacity(0.1)
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "There will be some message related to course progress",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  _getSubjects() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SubjectProgress(),
    ));
  }
}
