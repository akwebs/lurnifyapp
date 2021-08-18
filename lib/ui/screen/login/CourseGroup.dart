import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/screen.dart';

class CourseGroup extends StatefulWidget {
  CourseGroup(this.mobile);
  final mobile;
  @override
  _CourseGroupState createState() => _CourseGroupState(mobile);
}

class _CourseGroupState extends State<CourseGroup> {
  _CourseGroupState(this.mobile);
  final mobile;
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
      body: SafeArea(
        child: FutureBuilder(
          future: _getCourseGroup(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: _allData.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _allData[i]['type'],
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      ListView.builder(
                        itemCount: _allData[i]['detail'].length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, j) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CourseSelection(
                                    mobile,
                                    _allData[i]['detail'][j]['year'].toString(),
                                    _allData[i]['type'],
                                    _allData[i]['detail'][j]['courseName']),
                              ));
                            },
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 50),
                                child: Text(
                                  _allData[i]['detail'][j]['year'].toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
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
