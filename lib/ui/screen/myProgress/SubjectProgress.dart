import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myProgress/UnitProgress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class SubjectProgress extends StatefulWidget {
  @override
  _SubjectProgressState createState() => _SubjectProgressState();
}

class _SubjectProgressState extends State<SubjectProgress> {
  List _mySubjectProgress;
  Future _getMySubjectProgress()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String registrationSno = sp.getString("studentSno");
    String courseSno = sp.getString("courseSno");
    var url = baseUrl + "getSubjectProgressByCourse?registrationSno=" +
        registrationSno + "&courseSno=" + courseSno;
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
    _mySubjectProgress=List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Subject Progress"),
      ),
      body: FutureBuilder(
        future: _getMySubjectProgress(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              child: ListView.builder(
                itemCount: _mySubjectProgress.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context,i){
                  double subjectPercent=(_mySubjectProgress[i]['userCompletedTopics']/_mySubjectProgress[i]['totalTopics']*100);
                  return GestureDetector(
                    onTap: (){
                      _getUnits(_mySubjectProgress[i]['subjectSno']);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0,1)
                            ),
                          ]
                        ),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 150.0,
                              lineWidth: 8.0,
                              percent: _mySubjectProgress[i]['userCompletedTopics']/_mySubjectProgress[i]['totalTopics'],
                              animateFromLastPercent: true,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(subjectPercent.toStringAsFixed(2),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 20),),
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
                            Text("Total Completed "+_mySubjectProgress[i]['subjectName']+"%.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                            SizedBox(height: 10,),
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text("Click here for more detail",style: TextStyle(color: Colors.white),))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _getUnits(sno){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnitProgress(sno),));
  }
}
