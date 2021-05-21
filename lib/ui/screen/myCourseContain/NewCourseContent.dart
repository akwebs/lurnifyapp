import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/model/chapters.dart';
import 'package:lurnify/model/subject.dart';
import 'package:lurnify/model/units.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myCourseContain/ClassNotes.dart';
import 'package:lurnify/ui/screen/myCourseContain/FlashCard.dart';
import 'package:lurnify/ui/screen/myCourseContain/MicroVideo.dart';
import 'package:lurnify/ui/screen/myCourseContain/PreciseTheory.dart';
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
  List<Widget> _myTabs = [];
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
  Color _backgroundColor = AppColors.tileIconColors[3];
  Color subColor(int i) {
    if (i % 3 == 0) {
      return AppColors.tileIconColors[3];
    } else if (i % 3 == 1) {
      return AppColors.tileIconColors[2];
    } else if (i % 3 == 2) {
      return AppColors.tileIconColors[1];
    }
    return AppColors.tileIconColors[0];
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
    //_controller.addListener(_handleTabSelection);
    for (int i = 0; i < _subjects.length; i++) {
      _myTabs.add(CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: whiteColor),
            backgroundColor: Colors.transparent,
            title: Text(
              _subjects[i].subjectName.toUpperCase(),
              style: TextStyle(color: whiteColor, fontSize: 20),
            ),
            elevation: 0,
            floating: true,
            centerTitle: true,
            brightness: Brightness.dark,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: _unitGrids(_subjects[i].unitDtos),
          ),
        ],
      ));
    }
  }

  // _handleTabSelection() {
  //   setState(() {
  //     _backgroundColor = subColor(_controller.index);
  //     subject = _subjects[_controller.index].sno.toString();
  //     _units = _subjects[_controller.index].unitDtos;
  //   });
  // }

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
                          controller: _controller, children: _myTabs),
                    ),
                  ],
                ),
                bottomNavigationBar: TabBar(
                  controller: _controller,
                  // onTap: (i) => setState(() {
                  //   subject = _subjects[i].sno.toString();
                  //   _units = _subjects[i].unitDtos;
                  //   _onSelected(i);
                  // }),
                  tabs: List.generate(_subjects.length, (i) {
                    return new Tab(
                      text: _subjects[i].subjectName.toUpperCase(),
                    );
                  }),
                ),
              );
            } else {
              return Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    'assets/lottie/56446-walk.json',
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget _unitGrids(_unitDtos) {
    return _unitDtos.isEmpty
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
                return _unitSelect(i, _unitDtos);
              },
              childCount: _unitDtos.length,
            ),
          );
  }

  Widget _unitSelect(i, _unitDtos) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(5),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            unit = _unitDtos[i].sno.toString();
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: _chapterGrids(_unitDtos[i].chapterDtos),
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
                      _unitDtos[i].unitName,
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

              _pageNavigation(TopicDtos);
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

  void _pageNavigation(topicDtos) {
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
      _showPopup(context, topicDtos);
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

  void _showPopup(BuildContext context, topicDtos) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StCards("1", "Class Note", topicDtos),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: StCards("2", "Precise Theory", topicDtos),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StCards("3", "Flash Card", topicDtos),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: StCards("4", "Micro Video", topicDtos),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element

  Color _randomColor(int i) {
    if (i % 3 == 0) {
      return AppColors.tileIconColors[3];
    } else if (i % 3 == 1) {
      return AppColors.tileIconColors[2];
    } else if (i % 3 == 2) {
      return AppColors.tileIconColors[1];
    }
    return AppColors.tileIconColors[0];
  }
}

class StCards extends StatefulWidget {
  final String serial;
  final String cardName;
  final topicDtos;
  StCards(this.serial, this.cardName, this.topicDtos);

  @override
  _StCardsState createState() => _StCardsState(serial, cardName, topicDtos);
}

class _StCardsState extends State<StCards> {
  final String serial;
  final String cardName;
  final topicDtos;
  _StCardsState(this.serial, this.cardName, this.topicDtos);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      child: InkWell(
        onTap: () {
          _navigateToClass();
        },
        child: Material(
          color: Colors.transparent,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.notes),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.cardName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navigateToClass() {
    if (widget.serial == "1") {
      _getClassNotes(topicDtos.sno, topicDtos.topicName, topicDtos.subTopic);
    } else if (widget.serial == "2") {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PreciseTheory(
            topicDtos.sno, topicDtos.topicName, topicDtos.subTopic),
      ));
    } else if (widget.serial == "3") {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            FlashCard(topicDtos.sno, topicDtos.topicName, topicDtos.subTopic),
      ));
    } else if (widget.serial == "4") {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MicroVideo(topicDtos.sno, topicDtos.topicName, topicDtos.subTopic),
      ));
    }
  }

  _getClassNotes(topicSno, topicName, subtopic) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ClassNotes(topicSno, topicName, subtopic),
    ));
  }
}
