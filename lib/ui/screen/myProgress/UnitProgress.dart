import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/screen/myProgress/ChapterProgress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
class UnitProgress extends StatefulWidget {

  final sno;
  UnitProgress(this.sno);
  @override
  _UnitProgressState createState() => _UnitProgressState(sno);
}

class _UnitProgressState extends State<UnitProgress> {
  final sno;
  _UnitProgressState(this.sno);
  List _myUnitProgress;

  Future _getMyUnitProgress()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String registrationSno = sp.getString("studentSno");
    var url = baseUrl + "getUnitProgressBySubject?registrationSno=" +
        registrationSno + "&subjectSno=" + sno.toString();
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _myUnitProgress = resbody;
    print(_myUnitProgress);
  }

  @override
  void initState() {
    _myUnitProgress=List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Unit Progress"),
      ),
      body: FutureBuilder(
        future: _getMyUnitProgress(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              child: ListView.builder(
                itemCount: _myUnitProgress.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context,i){
                  double percent=_myUnitProgress[i]['userCompletedTopics']/_myUnitProgress[i]['totalTopics'];
                  double completedUnit=(_myUnitProgress[i]['userCompletedTopics']/_myUnitProgress[i]['totalTopics']*100);
                  return GestureDetector(
                    onTap: (){
                      _getChapters(_myUnitProgress[i]['unitSno']);
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
                              percent: percent>1?1:percent,
                              animateFromLastPercent: true,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(completedUnit>100?100.toString():completedUnit.toStringAsFixed(2),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 20),),
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
                            Text("Total Completed "+_myUnitProgress[i]['unitName']+"%.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
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
      )
    );
  }
  _getChapters(sno){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChapterProgress(sno),));
  }
}
