import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myProgress/SubjectProgress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CourseProgress extends StatefulWidget {
  @override
  _CourseProgressState createState() => _CourseProgressState();
}

class _CourseProgressState extends State<CourseProgress> {

  int userCompletedTopics=0,totalTopics=0;
  double _coursePercent=0;
  Future _getMyCourseProgress()async{
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String registrationSno = sp.getString("studentSno");
      String courseSno = sp.getString("courseSno");
      var url = baseUrl + "getProgressByCourse?registrationSno=" +
          registrationSno + "&courseSno=" + courseSno;
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      Map<String,dynamic> myProgress = resbody;
      totalTopics = myProgress['totalTopics'];
      userCompletedTopics = myProgress['userCompletedTopics'];
      _coursePercent = (userCompletedTopics / totalTopics);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Course Progress"),
      ),
      body: FutureBuilder(
        future: _getMyCourseProgress(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _getSubjects();
                      },
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                  child: Column(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 150.0,
                                        lineWidth: 8.0,
                                        percent: _coursePercent,
                                        animateFromLastPercent: true,
                                        center: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text((_coursePercent*100).toStringAsFixed(2),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 20),),
                                            SizedBox(height: 3,),
                                            Container(
                                              height: 1.5,
                                              width: 40,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                        progressColor: Colors.green,
                                      ),
                                      SizedBox(height: 10,),
                                      Text("Total Completed course %.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Text("Click here for more detail",style: TextStyle(color: Colors.white),))
                                    ],
                                  )
                              ),
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Text("There will be some message related to course progress",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }

  _getSubjects(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubjectProgress(),));
  }
}
