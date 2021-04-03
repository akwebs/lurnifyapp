import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myCourseContain/ClassNotes.dart';
import 'package:lurnify/ui/screen/myCourseContain/FlashCard.dart';
import 'package:lurnify/ui/screen/myCourseContain/MicroVideo.dart';
import 'package:lurnify/ui/screen/myCourseContain/PreciseTheory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';



class MyCourseContain extends StatefulWidget {
  @override
  _MyCourseContainState createState() => _MyCourseContainState();
}

class _MyCourseContainState extends State<MyCourseContain> {

  List _subjects;
  List _section;
  List _chapter;
  List _topic;
  String course="",subject="",unit="",chapter="",topic="",subTopic="",duration;
  var data;
  static double _selectedIndex = 0;
  int selectEdTopicIndex;
  _onSelected(double index) {
    setState(() => _selectedIndex = index);
  }
  ScrollController scrollController = ScrollController(
    initialScrollOffset: _selectedIndex, // or whatever offset you wish
    keepScrollOffset: true,
  );
  Future _getSubjects() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    course=sp.getString("courseSno");
    var url = baseUrl + "getSubjectsByCourse?courseSno="+sp.getString("courseSno");
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _subjects = resbody;
  }

  Future _getUnit(int sno) async {
    subject=sno.toString();
    _section=null;
    _chapter=null;
    var url = baseUrl +
        "getUnitsBySubject?subjectSno=" +
        sno.toString() +
        "";
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    setState(() {
      _section = resbody;
    });
  }

  Future _getChapters(int sno) async {
    unit=sno.toString();
    var url = baseUrl +
        "getChaptersByUnit?unitSno=" +
        sno.toString() +
        "";
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    setState(() {
      _chapter = resbody;
    });
  }

  Future _getTopic(int sno)async{
    chapter=sno.toString();
    var url = baseUrl +
        "getTopicsByChapter?chapterSno=" +
        sno.toString() +
        "";
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    setState(() {
      _topic = resbody;
    });
  }

  @override
  void initState() {
    data=_getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Content Selection"),
      ),
      body: FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    color: Colors.grey[200],
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
//                SizedBox(height: 8,),
                          firstRow(),
                          secondRow(),
                          thirdRow(),
                        ],
                      ),
                    ),

                  ),
                  forthRow(),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("Please Check your internet connection"),
            );
          }
        },
      ),
    );
  }

  Widget firstRow() {
    return _subjects == null ? Container() :Container(
      height:  80,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: _subjects.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                _getUnit(_subjects[i]['sno']);
              },
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.deepPurple, Colors.deepPurple[200]]),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                width: MediaQuery.of(context).size.width / 1.2,
                child: Center(
                    child: Text(
                      _subjects[i]['subjectName'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget secondRow() {
    return _section == null
        ? Container()
        : Container(
        height: _section.length == 0 ? 0 : 160,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: _section.length,
          itemBuilder: (_, i) {
            return Padding(
              padding: EdgeInsets.only(left: 8, top: 1, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  _getChapters(_section[i]["sno"]);
                },
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.grey[200], Colors.grey]),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ]),
                    width: MediaQuery.of(context).size.width / 3.2,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _section[i]["unitName"],
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 30,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Trigo",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    )),
              ),
            );
          },
        ));
  }

  Widget thirdRow() {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 20, right: 12),
      child: _chapter==null?Container():Container(
        height: 400,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              height: 380,
              child: ListView.builder(
                key: ObjectKey(_selectedIndex.toString()),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _chapter.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            _getTopic(_chapter[i]['sno']);
                            _onSelected(i.toDouble());
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.indigo[200], Colors.indigo])),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Chapter",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    _chapter[i]["chapterName"],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _selectedIndex!=i?Container(): Container(
                          height: 260,
                          width: double.infinity,
                          child: ListView(
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            children: [
                              Padding(
                                  padding:EdgeInsets.only(top: 10),
                                  child: topicRow()
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget topicRow(){
    return _topic == null
        ? Container()
        : Container(
        height: _topic.length == 0 ? 0 : 200,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: _topic.length,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: (){
                setState(() {
                  topic=_topic[i]['sno'].toString();
                  subTopic=_topic[i]['subtopic'].toString();
                  duration=_topic[i]['duration'].toString();
                  //selectEdTopicIndex=i;
                  print(duration);
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 8, top: 1, bottom: 10),
                child: Container(
                    width: MediaQuery.of(context).size.width *8/10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: selectEdTopicIndex!=i?[Colors.grey[200], Colors.grey]:[Colors.red[200], Colors.red]),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          child: Center(
                            child: Text(_topic[i]['topicName']),
                          ),
                        ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Spacer(),
                          Text("Subtopic: ",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w800),),
                          Text(_topic[i]['subtopic'],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600)),
                          Spacer()
                        ],
                      ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        _getClassNotes(_topic[i]['sno'],_topic[i]['topicName'],_topic[i]['subtopic']);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Icon(Icons.map),
                                            Text("Class Note")
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreciseTheory(_topic[i]['sno'],_topic[i]['topicName'],_topic[i]['subtopic']),));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Icon(Icons.map),
                                            Text("Precise Theory")
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FlashCard(_topic[i]['sno'],_topic[i]['topicName'],_topic[i]['subtopic']),));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Icon(Icons.map),
                                            Text("Flash Card")
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MicroVideo(_topic[i]['sno'],_topic[i]['topicName'],_topic[i]['subtopic']),));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Icon(Icons.map),
                                            Text("Micro Video")
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            );
          },
        ));
  }
  Widget forthRow() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        child: Center(
          child: ButtonTheme(
            minWidth: 150,
            child: RaisedButton(
              child: Text(
                "START",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              color: Colors.amberAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(width: 1, color: Colors.deepPurpleAccent)),
              onPressed: () {
                pageNavigation();
              },
            ),
          ),
        ),
      ),
    );
  }
  void pageNavigation(){
    print("page Key----"+topic);
    if(course.length<1){
      toastMethod("Please Select Course");
    }else if(subject.length<1){
      toastMethod("Please Select Subject");
    }else if(unit.length<1){
      toastMethod("Please Select Unit");
    }else if(chapter.length<1){
      toastMethod("Please Select Chapter");
    }else if(topic.length<1){
      toastMethod("Please Select Topic");
    }else {
      print(course);
//      if (pageKey == "1") {
//        Navigator.pushReplacement(context, MaterialPageRoute(
//            builder: (context) =>
//                StartTimer(course, subject, unit, chapter, topic,subTopic,duration)));
//      } else if (pageKey == "2") {
//        Navigator.pushReplacement(context, MaterialPageRoute(
//            builder: (context) =>
//                SyncYourTime(course, subject, unit, chapter, topic,duration)));
//      }
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  _getClassNotes(topicSno,topicName,subtopic){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClassNotes(topicSno,topicName,subtopic),));
  }
}
