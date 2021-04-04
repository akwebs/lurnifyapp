import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myCourseContain/ClassNotes.dart';
import 'package:lurnify/ui/screen/myCourseContain/FlashCard.dart';
import 'package:lurnify/ui/screen/myCourseContain/MicroVideo.dart';
import 'package:lurnify/ui/screen/myCourseContain/PreciseTheory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class CourseContent extends StatefulWidget {
  CourseContent({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CourseContent createState() => _CourseContent();
}

class _CourseContent extends State<CourseContent> {
  List _subjects;
  List _section;
  List _chapter;
  List _topic;
  String course = "",
      subject = "",
      unit = "",
      chapter = "",
      topic = "",
      subTopic = "",
      duration;
  var data;
  static double _selectedIndex = 0;
  int selectEdTopicIndex;
  _onSelected(double index) {
    setState(() => _selectedIndex = index);
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> _myList = [];

  ScrollController scrollController = ScrollController(
    initialScrollOffset: _selectedIndex, // or whatever offset you wish
    keepScrollOffset: true,
  );
  Future _getSubjects() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    course = sp.getString("courseSno");
    var url =
        baseUrl + "getSubjectsByCourse?courseSno=" + sp.getString("courseSno");
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _subjects = resbody;
    for (int i = 0; i < _subjects.length; i++) {
      _myList.add(BottomNavigationBarItem(
        icon: Icon(Icons.subject),
        label: _subjects[i]['subjectName'],
      ));
    }
  }

  Future _getUnit(int sno) async {
    subject = sno.toString();
    _section = null;
    _chapter = null;
    var url = baseUrl + "getUnitsBySubject?subjectSno=" + sno.toString() + "";
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    setState(() {
      _section = resbody;
    });
  }

  Future _getChapters(int sno) async {
    unit = sno.toString();
    var url = baseUrl + "getChaptersByUnit?unitSno=" + sno.toString() + "";
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    setState(() {
      _chapter = resbody;
    });
  }

  Future _getTopic(int sno) async {
    chapter = sno.toString();
    var url = baseUrl + "getTopicsByChapter?chapterSno=" + sno.toString() + "";
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
    data = _getSubjects();
    super.initState();
  }




  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        print("1111111111111111111111111"+index.toString());
        pageChanged(index);
      },
      children: <Widget>[
        Red(),
        Blue(),
        Yellow(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Course Content'),
                centerTitle: true,
              ),
              body: buildPageView(),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: 0,
                onTap: (index) {
                  bottomTapped(index);
                },
                items: _myList,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class Red extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
    );
  }
}
