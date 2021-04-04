import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/model/chapters.dart';
import 'package:lurnify/model/subject.dart';
import 'package:lurnify/model/units.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../../../model/units.dart';

class NewCourseContent extends StatefulWidget {
  @override
  _NewCourseContentState createState() => _NewCourseContentState();
}

class _NewCourseContentState extends State<NewCourseContent>
    with SingleTickerProviderStateMixin {
  List<Subject> _subjects = [];
  List<UnitDtos> _units = [];
  TabController _controller;
  int _selectedIndex = 0;
  String course = "",
      subject = "",
      unit = "",
      chapter = "",
      topic = "",
      subTopic = "",
      duration;
  var _data;
  Color _backgroundColor = AppColors.tileColors[3];
  Color subColor(int i) {
    if (i % 3 == 0) {
      return AppColors.tileColors[3];
    } else if (i % 3 == 1) {
      return AppColors.tileColors[2];
    } else if (i % 3 == 2) {
      return AppColors.tileColors[1];
    }
    return AppColors.tileColors[0];
  }

  _onSelected(int i) {
    setState(() {
      _backgroundColor = subColor(i);
    });
  }

  Future _getSubjects() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url =
        baseUrl + "getSubjectsByCourse?courseSno=" + sp.getString("courseSno");
    course = sp.getString("courseSno");
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );

    _subjects = (jsonDecode(response.body) as List)
        .map((e) => Subject.fromJson(e))
        .toList();
    if (_subjects.isNotEmpty) {
      _units = _subjects[0].unitDtos;
      subject = _subjects[0].sno.toString();
    }

    print(_subjects.length);
    _controller = TabController(length: _subjects.length, vsync: this);
  }


  @override
  void initState() {
    _data = _getSubjects();
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: TabBarView(
                  controller: _controller,
                  children: List.generate(_subjects.length, (index) {
                    return Center(
                      child: Text(_subjects[index].subjectName.toUpperCase()),
                    );
                  }),
                ),
                bottomNavigationBar: TabBar(
                  controller: _controller,
                  tabs: List.generate(_subjects.length, (index) {
                    return new Tab(
                        text: _subjects[index].subjectName.toUpperCase());
                  }),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
