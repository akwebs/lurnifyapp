import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myProgress/UnitProgress.dart';
import 'package:lurnify/widgets/componants/progressBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubjectProgress extends StatefulWidget {
  @override
  _SubjectProgressState createState() => _SubjectProgressState();
}

class _SubjectProgressState extends State<SubjectProgress> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("My Subject Progress"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getMySubjectProgress(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: ListView.builder(
                itemCount: _mySubjectProgress.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, i) {
                  double subjectPercent = (_mySubjectProgress[i]
                          ['userCompletedTopics'] /
                      _mySubjectProgress[i]['totalTopics'] *
                      100);
                  return GestureDetector(
                    onTap: () {
                      _getUnits(_mySubjectProgress[i]['subjectSno'],
                          _mySubjectProgress[i]['subjectName']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 2,
                                child: ProgressBar(
                                    progressValue: _mySubjectProgress[i]
                                            ['userCompletedTopics'] /
                                        _mySubjectProgress[i]['totalTopics'],
                                    taskText: _mySubjectProgress[i]
                                        ['subjectName']),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Total Completed " +
                                    _mySubjectProgress[i]['subjectName'] +
                                    "%.",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Click here for more detail",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _getUnits(sno, sname) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UnitProgress(sno, sname),
    ));
  }
}
