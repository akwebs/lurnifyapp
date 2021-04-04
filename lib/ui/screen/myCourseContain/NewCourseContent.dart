import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/model/chapters.dart';
import 'package:lurnify/model/subject.dart';
import 'package:lurnify/model/units.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myCourseContain/ClassNotes.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  // ignore: unused_field
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
                body: Stack(
                  children: [
                    Positioned.fill(
                      top: -Responsive.getPercent(
                          100, ResponsiveSize.HEIGHT, context),
                      left: -Responsive.getPercent(
                          50, ResponsiveSize.WIDTH, context),
                      right: -Responsive.getPercent(
                          40, ResponsiveSize.WIDTH, context),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 50,
                              spreadRadius: 2,
                              offset: Offset(20, 0)),
                          BoxShadow(
                              color: Colors.white12,
                              blurRadius: 0,
                              spreadRadius: -2,
                              offset: Offset(0, 0)),
                        ], shape: BoxShape.circle, color: _backgroundColor),
                      ),
                    ),
                    Container(
                      height: Responsive.getPercent(
                          35, ResponsiveSize.HEIGHT, context),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              top: 50,
                              left: 150,
                              right: -100,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 50,
                                          spreadRadius: 2,
                                          offset: Offset(20, 0)),
                                      BoxShadow(
                                          color: Colors.white12,
                                          blurRadius: 0,
                                          spreadRadius: -2,
                                          offset: Offset(0, 0)),
                                    ],
                                    shape: BoxShape.circle,
                                    color: _backgroundColor.withOpacity(0.2)),
                              ),
                            ),
                            Positioned.fill(
                              top: 50,
                              bottom: 50,
                              left: -300,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 50,
                                          spreadRadius: 1,
                                          offset: Offset(20, 0)),
                                      BoxShadow(
                                          color: Colors.white12,
                                          blurRadius: 0,
                                          spreadRadius: -2,
                                          offset: Offset(0, 0)),
                                    ],
                                    shape: BoxShape.circle,
                                    color: _backgroundColor.withOpacity(0.2)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: TabBarView(
                        controller: _controller,
                        children: List.generate(_subjects.length, (index) {
                          return CustomScrollView(
                            physics: BouncingScrollPhysics(),
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(20),
                                sliver: _unitGrids(index),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: TabBar(
                  labelColor: firstColor,
                  unselectedLabelColor: Colors.black26,
                  controller: _controller,
                  onTap: (i) => setState(() {
                    subject = _subjects[i].sno.toString();
                    _units = _subjects[i].unitDtos;
                    _onSelected(i);
                  }),
                  tabs: List.generate(_subjects.length, (i) {
                    return new Tab(
                      text: _subjects[i].subjectName.toUpperCase(),
                    );
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

  Widget _unitGrids(i) {
    return _units.isEmpty
        ? Container()
        : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 2 / 2.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext ctx, i) {
                return _unitSelect(i);
              },
              childCount: _units.length,
            ),
          );
  }

  Widget _unitSelect(i) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(5),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            unit = _units[i].sno.toString();
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: _chapterGrids(_units[i].chapterDtos),
                );
              },
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: whiteColor,
                      child: ImageIcon(
                        AssetImage(AppTile.tileIcons[3]),
                        size: 35,
                        color: firstColor,
                      ),
                    ),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(
                            0.0,
                            5.0,
                          ),
                          blurRadius: 8.0,
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      _units[i].unitName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.all(3),
                      lineHeight: 5,
                      percent: 0.5,
                      backgroundColor: Colors.grey,
                      progressColor: _randomColor(i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chapterGrids(List<ChapterDtos> _chapters) {
    return ListView.builder(
      itemCount: _chapters.length,
      itemBuilder: (context, i) {
        return _chapters == null
            ? Container()
            : _chapterSelect(_chapters[i], i);
      },
    );
  }

  Widget _chapterSelect(ChapterDtos _chapter, i) {
    List<Widget> list = [];
    if (_chapter.topicDtos != null) {
      for (var TopicDtos in _chapter.topicDtos) {
        list.add(Container(
          child: ListTile(
            title: Text(TopicDtos.topicName),
            onTap: () {
              topic = TopicDtos.sno.toString();
              if (TopicDtos.subTopic != null) {
                subTopic = TopicDtos.subTopic;
              }
              if (TopicDtos.duration != null) {
                duration = TopicDtos.duration;
              }

              _pageNavigation();
            },
          ),
        ));
      }
    }
    return ExpansionTile(
      title: Text(
        _chapter.chapterName,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onExpansionChanged: (bool) {
        chapter = _chapter.sno.toString();
      },
      children: list,
    );
  }

  void _pageNavigation() {
    print("page Key----" + topic);
    if (course.length < 1) {
      toastMethod("Please Select Course");
    } else if (subject.length < 1) {
      toastMethod("Please Select Subject");
    } else if (unit.length < 1) {
      toastMethod("Please Select Unit");
    } else if (chapter.length < 1) {
      toastMethod("Please Select Chapter");
    } else if (topic.length < 1) {
      toastMethod("Please Select Topic");
    } else {
      _showPopup(context);
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

  void _showPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Set backup account'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'user01@gmail.com');
                  Fluttertoast.showToast(
                      msg: 'user01@gmail.com', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle,
                        size: 36.0, color: Colors.orange),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: Text('user01@gmail.com'),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'user02@gmail.com');
                  Fluttertoast.showToast(
                      msg: 'user02@gmail.com', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 36.0, color: Colors.green),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: Text('user02@gmail.com'),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Add account');
                  Fluttertoast.showToast(
                      msg: 'Add account', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 36.0, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: Text('Add account'),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  // ignore: unused_element
  _getClassNotes(topicSno, topicName, subtopic) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ClassNotes(topicSno, topicName, subtopic),
    ));
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
}
