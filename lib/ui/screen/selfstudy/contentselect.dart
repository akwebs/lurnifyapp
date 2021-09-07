import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../helper/DBHelper.dart';
import '../../../config/data.dart';
import '../../../model/chapters.dart';
import '../../../model/subject.dart';
import '../../../model/topics.dart';
import '../../constant/constant.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math' as math;

import '../../../model/units.dart';
import 'starttimer.dart';
import 'syncyourtime.dart';

class ContentSelect extends StatefulWidget {
  final String pageKey;

  ContentSelect(this.pageKey);
  @override
  _ContentSelectState createState() => _ContentSelectState(pageKey);
}

class _ContentSelectState extends State<ContentSelect> {
  String pageKey;
  get cardPed => Responsive.getPercent(5, ResponsiveSize.WIDTH, context);
  _ContentSelectState(this.pageKey);
  List<Subject> _subjects = [];
  List<UnitDtos> _units = [];
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
    // var url =
    //     baseUrl + "getSubjectsByCourse?courseSno=" + sp.getString("courseSno");
    // course = sp.getString("courseSno");
    // http.Response response = await http.get(
    //   Uri.encodeFull(url),
    // );
    course = sp.getString("courseSno");
    DBHelper dbHelper = new DBHelper();
    Database db = await dbHelper.database;
    var a = await db.rawQuery(
        'select * from subject where courseSno=${sp.getString('courseSno')}');
    for (var b in a) {
      Subject subject = new Subject();
      subject.sno = b['sno'];
      subject.subjectName = b['subjectName'];
      var sql = await db
          .rawQuery("select * from unit where subjectSno='${b['sno']}'");
      List<UnitDtos> u = [];
      for (var c in sql) {
        UnitDtos unitDtos = new UnitDtos();
        unitDtos.sno = c['sno'];
        unitDtos.unitName = c['unitName'];

        var sql2 = await db
            .rawQuery("select * from chapter where unitSno=${c['sno']}");
        List<ChapterDtos> chap = [];
        for (var d in sql2) {
          ChapterDtos chapterDtos = new ChapterDtos();
          chapterDtos.sno = d['sno'];
          chapterDtos.chapterName = d['chapterName'];

          var sql3 = await db
              .rawQuery("select * from topic where chapterSno=${d['sno']}");
          List<TopicDtos> t = [];
          for (var e in sql3) {
            TopicDtos topicDtos = new TopicDtos();
            topicDtos.sno = e['sno'];
            topicDtos.topicName = e['topicName'];
            topicDtos.duration = e['duration'];
            topicDtos.topicImp = e['topicImp'];
            topicDtos.topicLabel = e['topicLabel'];
            t.add(topicDtos);
          }
          chapterDtos.topicDtos = t;
          chap.add(chapterDtos);
        }
        unitDtos.chapterDtos = chap;
        u.add(unitDtos);
      }
      subject.unitDtos = u;
      _subjects.add(subject);
    }
    print(_subjects);
    // _subjects = (jsonDecode(response.body) as List)
    //     .map((e) => Subject.fromJson(e))
    //     .toList();
    if (_subjects.isNotEmpty) {
      _units = _subjects[0].unitDtos;
      subject = _subjects[0].sno.toString();
    }
  }

  @override
  void initState() {
    _data = _getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: Stack(
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: <Widget>[
                          SliverAppBar(
                            iconTheme: IconThemeData(color: whiteColor),
                            backgroundColor: Colors.transparent,
                            title: Text(
                              'Content Selection',
                              style: TextStyle(color: whiteColor, fontSize: 20),
                            ),
                            elevation: 0,
                            floating: true,
                            expandedHeight: 200,
                            centerTitle: true,
                            brightness: Brightness.dark,
                            flexibleSpace: _subjectSelect(),
                            collapsedHeight: 100,
                          ),
                          // ontopFixed(
                          //   _subjectSelect(),
                          // ),

                          SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: _unitGrids(),
                          ),

                          // _subUnits()
                          // subUnits(),
                          // thirdRow(),
                        ],
                      ),
                    ),
                  )
                ],
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
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.help,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _subjectSelect() {
    return _subjects == null
        ? Container(
            child: Text('No Course Selected'),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.horizontal,
              itemCount: _subjects.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          subject = _subjects[i].sno.toString();
                          _units = _subjects[i].unitDtos;
                          _onSelected(i);
                        });
                      },
                      child: Text(
                        _subjects[i].subjectName,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _unitGrids() {
    return _units.isEmpty
        ? SliverGrid(
            gridDelegate: null,
            delegate: SliverChildBuilderDelegate(
              (BuildContext ctx, i) {
                return _unitSelect(i);
              },
              childCount: _units.length,
            ),
          )
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
                      percent: 0.8,
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
              if (TopicDtos.subtopic != null) {
                subTopic = TopicDtos.subtopic;
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
      leading: CircleAvatar(
        backgroundColor: whiteColor,
        foregroundColor: firstColor,
        radius: 18,
        child: ImageIcon(
          AssetImage(AppTile.tileIcons[3]),
          color: firstColor,
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
      _toastMethod("Please Select Course");
    } else if (subject.length < 1) {
      _toastMethod("Please Select Subject");
    } else if (unit.length < 1) {
      _toastMethod("Please Select Unit");
    } else if (chapter.length < 1) {
      _toastMethod("Please Select Chapter");
    } else if (topic.length < 1) {
      _toastMethod("Please Select Topic");
    } else {
      print(course);
      if (pageKey == "1") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StartTimer(course, subject, unit, chapter,
                    topic, subTopic, duration)));
      } else if (pageKey == "2") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SyncYourTime(
                    course, subject, unit, chapter, topic, duration)));
      }
    }
  }

  void _toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }

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

  SliverPersistentHeader ontopFixed(Widget child) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 0,
        maxHeight: 100.0,
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
