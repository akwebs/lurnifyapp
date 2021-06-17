import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:http/http.dart' as http;

class RevisionZone extends StatefulWidget {
  @override
  _RevisionZoneState createState() => _RevisionZoneState();
}

Color _backgroundColor = AppColors.tileIconColors[3];

class _RevisionZoneState extends State<RevisionZone> {
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
  static List rDays = [
    '30 Days',
    '60 Days',
    '90 Days',
  ];
  List<bool> _isSelected = List.generate(rDays.length, (i) => false);
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Test Performance':
        break;
      case 'Topic Importance':
        break;
    }
  }

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
    return FutureBuilder(
      future: data,
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
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: firstColor,
                          textColor: whiteColor,
                          onPressed: () {
                            setState(() {
                              _isSelected[i] = !_isSelected[i];
                              print(_isSelected[i]);
                              print(rDays[i]);
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
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton(
                    //     iconSize: 40,
                    //     items: _subjectItem,
                    //     isExpanded: true,
                    //     value: _selectedSubjectSno,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w800,
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //     ),
                    //     onChanged: (value) {
                    //       print(value);
                    //       setState(() {
                    //         _selectedSubjectSno = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton(
                    //     iconSize: 40,
                    //     items: _days,
                    //     isExpanded: true,
                    //     value: _selectedDay,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w800,
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //     ),
                    //     onChanged: (value) {
                    //       print(value);
                    //       setState(() {
                    //         _selectedDay = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton(
                    //     iconSize: 40,
                    //     items: _topicImp,
                    //     isExpanded: true,
                    //     value: _selectedTopicImp,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w800,
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //     ),
                    //     onChanged: (value) {
                    //       print(value);
                    //       setState(() {
                    //         _selectedTopicImp = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton(
                    //     iconSize: 40,
                    //     items: _performance,
                    //     isExpanded: true,
                    //     value: _selectedPerformance,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w800,
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //     ),
                    //     onChanged: (value) {
                    //       print(value);
                    //       setState(() {
                    //         _selectedPerformance = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: RaisedButton(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10)),
                    //         child: Text("Search"),
                    //         onPressed: () {
                    //           _search();
                    //         },
                    //       ),
                    //     )
                    //   ],
                    // ),
                    _topics.isEmpty
                        ? Container(
                            child: Center(
                              child: Text(
                                  'Please Select Options to Get Topics to Revise'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _topics.length,
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: cards(i),
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _search();
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: Row(
              children: List.generate(_subjects.length, (i) {
                return new Expanded(
                  child: RaisedButton(
                    color: firstColor,
                    textColor: whiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    onPressed: () {},
                    child: Text(_subjects[i]['subjectName']),
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

  Widget cards(int i) {
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
                        rating: _topics[i]['topicRating'],
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
                        _topics[i]['topicName'],
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
                    'Path > from > Course > to > Chapter',
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
                    _topics[i]['subTopic'],
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
                    child: topicInfo(i, 'Studied', _topics[i]['isStudied']),
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
                    child: topicInfo(
                      i,
                      'Test Score',
                      _topics[i]['testScore'] + "%",
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
                    child: topicInfo(i, 'Revision', _topics[i]['revision']),
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
                      child: topicInfo(
                          i,
                          'Last Studied',
                          _topics[i]['lastStudied'].round().toString() +
                              ' days ago')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column topicInfo(int i, String heading, String detail) {
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
