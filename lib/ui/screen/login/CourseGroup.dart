import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/screen.dart';
import 'package:lurnify/ui/constant/constant.dart';

class CourseGroup extends StatefulWidget {
  CourseGroup(this.mobile);
  final mobile;
  @override
  _CourseGroupState createState() => _CourseGroupState(mobile);
}

class _CourseGroupState extends State<CourseGroup> {
  _CourseGroupState(this.mobile);
  final mobile;
  int selectedIndex;
  DBHelper _dbHelper = new DBHelper();
  List<Map<String, dynamic>> _allData = [];

  _getCourseGroup() async {
    try {
      var url = baseUrl + "getCourseGroup";
      print(url);
      var response = await http.get(url);
      List list = jsonDecode(response.body);
      await _dbHelper.insertCourseGroupBatch(list);
      _allData = await _dbHelper.getCourseType();
      print(_allData);
    } catch (e) {
      print('_getCourseGroup : ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Programs"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _getCourseGroup(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: _allData.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, i) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: firstColor,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _allData[i]['type'],
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    _allData[i]['type'] == 'Engineering'
                                        ? 'IIT JEE-Main/Advance'
                                        : 'NEET UG',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   _allData[i]['type'],
                            //   style:
                            //       TextStyle(color: Colors.black, fontSize: 24),
                            // ),
                            ListView.builder(
                              itemCount: _allData[i]['detail'].length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, j) {
                                return ListTile(
                                  selected: i == selectedIndex,
                                  title: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: selectedIndex == 5
                                            ? Icon(Icons.check)
                                            : Container(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _allData[i]['detail'][j]
                                              ['courseName'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    _allData[i]['detail'][j]['year'] +
                                        ' Year Foundation Course ',
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CourseSelection(
                                          mobile,
                                          _allData[i]['detail'][j]['year']
                                              .toString(),
                                          _allData[i]['type'],
                                          _allData[i]['detail'][j]
                                              ['courseName']),
                                    ));
                                  },
                                );
                                // Text(
                                //   _allData[i]['detail'][j]['courseName']
                                //       .toString(),
                                //   style: TextStyle(fontSize: 20),
                                // ),
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
