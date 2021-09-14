import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/helper/revision_zone.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:http/http.dart' as http;

class RevisionZone extends StatefulWidget {
  @override
  _RevisionZoneState createState() => _RevisionZoneState();
}

// ignore: unused_element
Color _backgroundColor = AppColors.tileIconColors[3];

class _RevisionZoneState extends State<RevisionZone> {
  // List<DropdownMenuItem<String>> _days = [];
  // List<DropdownMenuItem<String>> _topicImp = [];
  // List<DropdownMenuItem<String>> _performance = [];
  // List<DropdownMenuItem<String>> _subjectItem = [];
  var data;
  List result = [];
  // String _selectedDay = "0";
  // String _selectedTopicImp = "0";
  // String _selectedPerformance = "0";
  // String _selectedSubjectSno = "0";
  // ignore: unused_field
  List _topics = [];
  // ignore: unused_field
  List _subjects = [];
  static List rDays = [
    '30 Days',
    '60 Days',
    '90 Days',
  ];
  List<bool> _isSelected = List.generate(rDays.length, (i) => false);
  String _selectedDateRange = "90 Days";
  int _selectedSubjectIndex = 0;

  void handleClick(String value) {
    switch (value) {
      case 'Test Performance':
        break;
      case 'Topic Importance':
        break;
    }
  }

  Future _getRevisionZone() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String firstDate=now.subtract(Duration(days: 60)).toString();
    String secondDate=now.subtract(Duration(days: 31)).toString();
    RevisionZoneHelper helper = new RevisionZoneHelper();

    if(_selectedDateRange=='30 Days'){
      firstDate=now.subtract(Duration(days: 60)).toString();
      secondDate=now.subtract(Duration(days: 31)).toString();
    }else if(_selectedDateRange=='60 Days'){
      firstDate=now.subtract(Duration(days: 90)).toString();
      secondDate=now.subtract(Duration(days: 61)).toString();
    }else if(_selectedDateRange=='90 Days'){
      firstDate=now.subtract(Duration(days: 30)).toString();
      secondDate=now.subtract(Duration(days: 0)).toString();
    }

    List<Map<String,dynamic>> data= await helper.getRevisionZone(sp.getString("studentSno"),firstDate,secondDate);

    // var url = baseUrl +
    //     "getRevisionZone?days=" +
    //     _selectedDateRange +
    //     "&regSno=" +
    //     sp.getString("studentSno");
    // print(url);
    // http.Response response = await http.post(
    //   Uri.encodeFull(url),
    // );
    // List resbody = jsonDecode(response.body);
    // print(resbody);
    List<RevisionModel> list = [];
    if(data!=null){
      data.forEach((element) {
        RevisionModel model = new RevisionModel();
        model.subjectSno = element['subjectSno'];
        model.subjectName = element['subjectName'];
        list.add(model);
      });
    }
    // convert each item to a string by using JSON encoding
    final jsonList = list.map((item) => jsonEncode(item)).toList();

    // using toSet - toList strategy
    final uniqueJsonList = jsonList.toSet().toList();

    // convert each item back to the original form using JSON decoding
    result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
    print(result);
    result.forEach((el) {
      var a = data
          .where((element) => element['subjectSno'] == el['subjectSno'])
          .toList();
      el['topic'] = a;
    });

    print(result);
  }

  @override
  void initState() {
    // data = _getRevisionZone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getRevisionZone(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Revision Zone'),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Row(
                  children: List.generate(rDays.length, (i) {
                    return new Expanded(
                      // ignore: deprecated_member_use
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: firstColor,
                          textColor: whiteColor,
                          onPressed: () {
                            setState(() {
                              _isSelected[i] = !_isSelected[i];
                              _selectedDateRange = rDays[i];
                              _getRevisionZone();
                            });
                          },
                          child: Text(rDays[i]),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list),
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Topic Importance', 'Test Performance'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    result.isEmpty
                        ? Container()
                        : result[_selectedSubjectIndex]['topic'].isEmpty
                            ? Container(
                                child: Center(
                                  child: Text(
                                      'Please Select Options to Get Topics to Revise'),
                                ),
                              )
                            : ListView.builder(
                                itemCount: result[_selectedSubjectIndex]
                                        ['topic']
                                    .length,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _cards(i,
                                        result[_selectedSubjectIndex]['topic']),
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // _search();
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: Row(
              children: List.generate(result.length, (i) {
                return new Expanded(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: firstColor,
                    textColor: whiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    onPressed: () {},
                    child: Text(result[i]['subjectName']),
                  ),
                );
              }),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _cards(int i, List topics) {
    int days = DateTime.now()
        .difference(DateTime.parse(topics[i]['lastStudied']))
        .inDays;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(width: 1, color: firstColor)),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SmoothStarRating(
                        rating: topics[i]['topicImp'],
                        size: 16,
                        starCount: 5,
                        allowHalfRating: true,
                        color: Colors.amber,
                        isReadOnly: true,
                        // defaultIconData: Icons.blur_off,
                        borderColor: Colors.amber,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        topics[i]['topicName'],
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.add_circle_outline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: _randomColor(i),
                border:
                    Border(bottom: BorderSide(width: 0.5, color: firstColor))),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Info :',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${topics[i]['subjectName']} > ${topics[i]['unitName']} > ${topics[i]['chapterName']} ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Sub Topics :',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    topics[i]['subTopic'],
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: _topicInfo(i, 'Studied',
                        topics[i]['isUserStudied'] == 1 ? "Yes" : "No"),
                    decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 0.5, color: Colors.grey[500])),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: _topicInfo(
                      i,
                      'Test Score',
                      topics[i]['lastTestScore'].toString() + "%",
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 0.5, color: Colors.grey[500])),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: _topicInfo(
                        i, 'Revision', topics[i]['revision'].toString()),
                    decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 0.5, color: Colors.grey[500])),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      child: _topicInfo(
                          i, 'Last Studied', days.toString() + ' days ago')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _topicInfo(int i, String heading, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        Text(
          detail,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

Color _randomColor(int i) {
  if (i % 3 == 0) {
    return AppColors.tileColors[3];
  } else if (i % 3 == 1) {
    return AppColors.tileColors[2];
  } else if (i % 3 == 2) {
    return AppColors.tileColors[1];
  }
  return AppColors.tileColors[0];
}

class RevisionModel {
  String subjectSno;
  String subjectName;

  RevisionModel({this.subjectName, this.subjectSno});

  RevisionModel.fromJson(Map<String, dynamic> json) {
    subjectName = json['subjectName'];
    subjectSno = json['subjectSno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectName'] = this.subjectName;
    data['subjectSno'] = this.subjectSno;
    return data;
  }
}
