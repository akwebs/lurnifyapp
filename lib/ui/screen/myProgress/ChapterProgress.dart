import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myProgress/TopicProgress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChapterProgress extends StatefulWidget {
  final sno;
  ChapterProgress(this.sno);
  @override
  _ChapterProgressState createState() => _ChapterProgressState(sno);
}

class _ChapterProgressState extends State<ChapterProgress> {
  final sno;
  _ChapterProgressState(this.sno);
  List _myChapterProgress;

  Future _getMyChapterProgress()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String registrationSno = sp.getString("studentSno");
    var url = baseUrl + "getChapterProgressByUnit?registrationSno=" +
        registrationSno + "&unitSno=" + sno.toString();
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _myChapterProgress = resbody;
    print(_myChapterProgress);
  }

  @override
  void initState() {
    _myChapterProgress=List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chapter Progress"),
      ),
      body: FutureBuilder(
        future: _getMyChapterProgress(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              child: ListView.builder(
                itemCount: _myChapterProgress.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context,i){
                  double percent=_myChapterProgress[i]['userCompletedTopics']/_myChapterProgress[i]['totalTopics'];
                  double completedChapter=(_myChapterProgress[i]['userCompletedTopics']/_myChapterProgress[i]['totalTopics']*100);
                  return GestureDetector(
                    onTap: (){
                      _getTopics(_myChapterProgress[i]['chapterSno']);
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
                                  Text(completedChapter>100?100.toString():completedChapter.toStringAsFixed(2),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 20),),
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
                            Text("Total Completed "+_myChapterProgress[i]['chapterName']+"%.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
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

  _getTopics(sno){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopicProgress(sno),));
  }
}
