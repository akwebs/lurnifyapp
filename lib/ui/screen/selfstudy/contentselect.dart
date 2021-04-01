import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/model/chapters.dart';
import 'package:lurnify/model/subject.dart';
import 'package:lurnify/model/topics.dart';
import 'package:lurnify/model/units.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/selfstudy/starttimer.dart';
import 'package:lurnify/ui/screen/selfstudy/syncyourtime.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

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
  var _data;

  Future _getSubjects() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url =
        baseUrl + "getSubjectsByCourse?courseSno=" + sp.getString("courseSno");
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );

    _subjects = (jsonDecode(response.body) as List)
        .map((e) => Subject.fromJson(e))
        .toList();
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
        builder: (conext, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text('Content Selection'),
                    elevation: 3,
                    floating: true,
                    expandedHeight: 70,
                    centerTitle: true,
                  ),
                  ontopFixed(
                    _subjectSelect(),
                  ),

                  // SliverPadding(
                  //   padding: const EdgeInsets.all(20),
                  //   sliver: _unitGrids(),
                  // ),
                  // _subUnits()
                  // subUnits(),
                  // thirdRow(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _subjectSelect() {
    return _subjects == null
        ? Container(
            child: Text('No Course Select'),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.horizontal,
              itemCount: _subjects.length,
              itemBuilder: (_, i) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAlias,
                  borderOnForeground: false,
                  child: SizedBox(
                    width: Responsive.getPercent(
                        60, ResponsiveSize.WIDTH, context),
                    child: Container(
                      color: _randomColor(i),
                      child: InkWell(
                        onTap: () {
                          //_getUnit(_subjects[i].sno);
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              _subjects[i].subjectName,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _unitGrids(section) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 2 / 2.1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext ctx, i) {
          return _unitSelect(section);
        },
        childCount: section.length,
      ),
    );
  }

  Widget _unitSelect(section) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(5),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // _getChapters(_section[i].sno);
            // showModalBottomSheet<void>(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return Container(
            //       padding: EdgeInsets.symmetric(vertical: 32),
            //       child: _chapterGrids(),
            //     );
            //   },
            // );
          },
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                      section.unitName,
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
                      progressColor: Colors.red, //_randomColor(section),
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

  SliverPersistentHeader ontopFixed(Widget child) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 90.0,
        maxHeight: 100.0,
        child: Card(
          elevation: 3,
          margin: EdgeInsets.zero,
          child: Container(
            margin: EdgeInsets.only(top: 25, bottom: 10),
            child: Center(child: child),
          ),
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
