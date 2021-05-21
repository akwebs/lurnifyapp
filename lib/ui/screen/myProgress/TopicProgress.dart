import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
class TopicProgress extends StatefulWidget {
  final chapterSno;
  TopicProgress(this.chapterSno);
  @override
  _TopicProgressState createState() => _TopicProgressState(chapterSno);
}

class _TopicProgressState extends State<TopicProgress> {
  final chapterSno;
  _TopicProgressState(this.chapterSno);
  List _topicList=[];

  Future _getTopicsByChapter()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url=baseUrl+"getTopicProgressByChapter?chapterSno="+chapterSno.toString()+"&regSno="+sp.getString("studentSno").toString();
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    _topicList=resbody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topic Progresss"),
      ),
      body: FutureBuilder(
        future: _getTopicsByChapter(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: _topicList.length,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context,i){
                        return cards(i);
                      },
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
      ),
    );
  }

  Widget cards(int i){
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*2.5/10,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothStarRating(
                    rating: _topicList[i]['topicRating'],
                    size: 20,
                    starCount: 5,
                    allowHalfRating: true,
                    color: Colors.amber,
                    isReadOnly: true,
                    // defaultIconData: Icons.blur_off,
                    borderColor: Colors.amber,
                  ),
                  Spacer(),
                  Text(_topicList[i]['topicName'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                  Spacer(),
                  Spacer(),
                  Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SubTopics : ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                  Expanded(
                    child: Text(_topicList[i]['subTopic'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4),bottomRight: Radius.circular(4))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      children: [
                        Text("Studied",style: TextStyle(color: Colors.purple,fontSize: 16,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),),
                        SizedBox(height: 5,),
                        Text(_topicList[i]['isStudied'],style: TextStyle(color: Colors.redAccent,fontSize: 22,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 1,
                    decoration: BoxDecoration(
                        color: Colors.black54
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      children: [
                        Text("Test Score",style: TextStyle(color: Colors.purple,fontSize: 16,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),),
                        SizedBox(height: 5,),
                        Text(_topicList[i]['testScore']+"%",style: TextStyle(color: Colors.redAccent,fontSize: 22,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 1,
                    decoration: BoxDecoration(
                        color: Colors.black54
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      children: [
                        Text("Revision",style: TextStyle(color: Colors.purple,fontSize: 16,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),),
                        SizedBox(height: 5,),
                        Text(_topicList[i]['revision'],style: TextStyle(color: Colors.redAccent,fontSize: 22,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 1,
                    decoration: BoxDecoration(
                        color: Colors.black54
                    ),
                  ),Container(
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      children: [
                        Text("Last Studied",style: TextStyle(color: Colors.purple,fontSize: 16,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),),
                        SizedBox(height: 5,),
                        Text(_topicList[i]['lastStudied'].round().toString(),style: TextStyle(color: Colors.redAccent,fontSize: 22,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic)),
                        Text("Days ago",style: TextStyle(color: Colors.purple,fontSize: 16,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
