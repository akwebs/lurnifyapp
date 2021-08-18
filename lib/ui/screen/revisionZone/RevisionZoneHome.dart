import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:http/http.dart' as http;

class RevisionZoneHome extends StatefulWidget {
  @override
  _RevisionZoneHomeState createState() => _RevisionZoneHomeState();
}

class _RevisionZoneHomeState extends State<RevisionZoneHome> {
  List<DropdownMenuItem<String>> _days = [];
  List<DropdownMenuItem<String>> _topicImp = [];
  List<DropdownMenuItem<String>> _performance = [];
  List<DropdownMenuItem<String>> _subjectItem = [];
  var data;

  String _selectedDay = "0";
  String _selectedTopicImp = "0";
  String _selectedPerformance = "0";
  String _selectedSubjectSno = "0";
  List _topics = [];
  List _subjects = [];

  Future _getSubjects() async {
    _subjects = [];
    _getHomePageData();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url =
        baseUrl + "getSubjectsByCourse?courseSno=" + sp.getString("courseSno");
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _subjects = resbody;
    _subjectItem.add(DropdownMenuItem(
      child: Text("Please Select Subject"),
      value: "0",
    ));
    for (int i = 0; i < _subjects.length; i++) {
      _subjectItem.add(DropdownMenuItem(
        child: Text(_subjects[i]['subjectName']),
        value: _subjects[i]['sno'].toString(),
      ));
    }
  }

  Future _getHomePageData() async {
    _days = [];
    _topicImp = [];
    _performance = [];
    setState(() {
      _days.add(DropdownMenuItem(
        child: Text("Please Select Date Range "),
        value: "0",
      ));
      _days.add(DropdownMenuItem(
        child: Text("1 - 2 Months "),
        value: "1",
      ));
      _days.add(DropdownMenuItem(
        child: Text("2 - 3 Months"),
        value: "2",
      ));
      _days.add(DropdownMenuItem(
        child: Text("Older than 3 Months"),
        value: "3",
      ));

      _topicImp.add(DropdownMenuItem(
        child: Text("Please Select Topic Importance"),
        value: "0",
      ));
      _topicImp.add(DropdownMenuItem(
        child: Text("4-5"),
        value: "1",
      ));
      _topicImp.add(DropdownMenuItem(
        child: Text("3-4"),
        value: "2",
      ));
      _topicImp.add(DropdownMenuItem(
        child: Text("3 and below"),
        value: "3",
      ));

      _performance.add(DropdownMenuItem(
        child: Text("Please Select Test Performance"),
        value: "0",
      ));
      _performance.add(DropdownMenuItem(
        child: Text("Medium"),
        value: "1",
      ));
      _performance.add(DropdownMenuItem(
        child: Text("High"),
        value: "2",
      ));
      _performance.add(DropdownMenuItem(
        child: Text("Top"),
        value: "3",
      ));
    });
  }

  @override
  void initState() {
    data = _getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Revision Zone"),
        ),
        body: FutureBuilder(
          future: data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconSize: 40,
                          items: _subjectItem,
                          isExpanded: true,
                          value: _selectedSubjectSno,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 16,
                              shadows: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedSubjectSno = value;
                            });
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconSize: 40,
                          items: _days,
                          isExpanded: true,
                          value: _selectedDay,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 16,
                              shadows: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedDay = value;
                            });
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconSize: 40,
                          items: _topicImp,
                          isExpanded: true,
                          value: _selectedTopicImp,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 16,
                              shadows: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedTopicImp = value;
                            });
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconSize: 40,
                          items: _performance,
                          isExpanded: true,
                          value: _selectedPerformance,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 16,
                              shadows: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _selectedPerformance = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("Search"),
                              onPressed: () {
                                _search();
                              },
                            ),
                          )
                        ],
                      ),
                      _topics.isEmpty
                          ? Container()
                          : ListView.builder(
                              itemCount: _topics.length,
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, i) {
                                return cards(i);
                              },
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

  Widget cards(int i) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2.5 / 10,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothStarRating(
                    rating: 5,
                    size: 20,
                    starCount: 5,
                    color: Colors.amber,
                  ),
                  Spacer(),
                  Text(
                    _topics[i]['topicName'],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
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
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SubTopics : ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Expanded(
                    child: Text(_topics[i]['subTopic'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Text(
                          "Studied",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(_topics[i]['isStudied'],
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 1,
                    decoration: BoxDecoration(color: Colors.black54),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Text(
                          "Test Score",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(_topics[i]['testScore'] + "%",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 1,
                    decoration: BoxDecoration(color: Colors.black54),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Text(
                          "Revision",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(_topics[i]['revision'],
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 1,
                    decoration: BoxDecoration(color: Colors.black54),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Text(
                          "Last Studied",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(_topics[i]['lastStudied'].round().toString(),
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic)),
                        Text(
                          "Days ago",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic),
                        ),
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

  Future _search() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl +
        "getRevisionZone?days=" +
        _selectedDay +
        "&topicImp=" +
        _selectedTopicImp +
        "&performance=" +
        _selectedPerformance +
        "&regSno=" +
        sp.getString("studentSno") +
        "&subjectSno=" +
        _selectedSubjectSno +
        "&courseSno=" +
        sp.getString("courseSno");
    print(url);
    http.Response response = await http.post(
      Uri.encodeFull(url),
    );
    var responseData = jsonDecode(response.body);
    print(responseData);
    setState(() {
      _topics = responseData;
    });
  }
}
