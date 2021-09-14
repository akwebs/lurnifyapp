import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/helper/my_progress_repo.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myProgress/topic_progress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';

class UnitProgress extends StatefulWidget {
  final sno;
  final String sname;
  UnitProgress(this.sno, this.sname);
  @override
  _UnitProgressState createState() => _UnitProgressState(sno, sname);
}

Color _backgroundColor = AppColors.tileIconColors[3];

class _UnitProgressState extends State<UnitProgress> {
  final sno;
  final String sname;
  _UnitProgressState(this.sno, this.sname);
  List result = [];

  Future _getMyUnitProgress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String registrationSno = sp.getString("studentSno");
    // var url = baseUrl +
    //     "getChapterProgressByUnit?registrationSno=" +
    //     registrationSno +
    //     "&unitSno=" +
    //     sno.toString();
    // print(url);
    // http.Response response = await http.get(
    //   Uri.encodeFull(url),
    // );
    // var resbody = jsonDecode(response.body);
    MyProgressRepo myProgressRepo = new MyProgressRepo();
    List<Map<String, dynamic>> _myUnitProgress = await myProgressRepo.getChapterTopicByUnit(sno.toString(), registrationSno, '0', 'Complete');

    List<ChapterModel> list = [];
    _myUnitProgress.forEach((element) {
      ChapterModel model = new ChapterModel();
      model.sno = element['chapterSno'].toString();
      model.chapterName = element['chapterName'];
      model.completedTopicByUser = element['completedTopicByUser'];
      model.totalChapterTopic = element['totalChapterTopic'];
      list.add(model);
    });

    // convert each item to a string by using JSON encoding
    final jsonList = list.map((item) => jsonEncode(item)).toList();

    // using toSet - toList strategy
    final uniqueJsonList = jsonList.toSet().toList();

    // convert each item back to the original form using JSON decoding
    result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    result.forEach((el) {
      var a = _myUnitProgress.where((element) => element['chapterSno'] == el['sno']).toList();
      el['topic'] = a;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMyUnitProgress(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  top: -Responsive.getPercent(100, ResponsiveSize.HEIGHT, context),
                  left: -Responsive.getPercent(50, ResponsiveSize.WIDTH, context),
                  right: -Responsive.getPercent(40, ResponsiveSize.WIDTH, context),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 2, offset: Offset(20, 0)),
                      BoxShadow(color: Colors.white12, blurRadius: 0, spreadRadius: -2, offset: Offset(0, 0)),
                    ], shape: BoxShape.circle, color: _backgroundColor),
                  ),
                ),
                Container(
                  height: Responsive.getPercent(35, ResponsiveSize.HEIGHT, context),
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
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 2, offset: Offset(20, 0)),
                              BoxShadow(color: Colors.white12, blurRadius: 0, spreadRadius: -2, offset: Offset(0, 0)),
                            ], shape: BoxShape.circle, color: _backgroundColor.withOpacity(0.2)),
                          ),
                        ),
                        Positioned.fill(
                          top: 50,
                          bottom: 50,
                          left: -300,
                          child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 1, offset: Offset(20, 0)),
                              BoxShadow(color: Colors.white12, blurRadius: 0, spreadRadius: -2, offset: Offset(0, 0)),
                            ], shape: BoxShape.circle, color: _backgroundColor.withOpacity(0.2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    PreferredSize(
                      preferredSize: Size.fromHeight(70),
                      child: Container(
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          title: Text(sname + ' Progress'),
                          centerTitle: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: result.length,
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, i) {
                            double percent = result[i]['completedTopicByUser'] / result[i]['totalChapterTopic'];
                            double completedUnit = (result[i]['completedTopicByUser'] / result[i]['totalChapterTopic'] * 100);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                              child: AspectRatio(
                                aspectRatio: 4 / 1,
                                child: InkWell(
                                  onTap: () {
                                    _getChapters(result[i]['chapterSno'], result[i]['chapterName'], result[i]['topic']);
                                  },
                                  child: Card(
                                    margin: EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Image.asset(
                                              AppSlider.cardimage[0],
                                              fit: BoxFit.contain,
                                              height: 50,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              result[i]['chapterName'],
                                              style: TextStyle(color: whiteColor),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: CircularPercentIndicator(
                                              radius: 50,
                                              lineWidth: 5.0,
                                              animation: true,
                                              percent: percent > 1 ? 1 : percent,
                                              animateFromLastPercent: true,
                                              center: Text(
                                                completedUnit > 100 ? 100.toString() : completedUnit.toStringAsFixed(2),
                                                style: TextStyle(
                                                  color: whiteColor,
                                                ),
                                              ),
                                              backgroundColor: Color.fromARGB(30, 255, 255, 255),
                                              circularStrokeCap: CircularStrokeCap.round,
                                              progressColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: _randomGradient(i),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

  Gradient _randomGradient(int i) {
    if (i % 3 == 0) {
      return AppSlider.sliderGradient[0];
    } else if (i % 3 == 1) {
      return AppSlider.sliderGradient[2];
    } else if (i % 3 == 2) {
      return AppSlider.sliderGradient[1];
    }
    return AppSlider.sliderGradient[1];
  }

  _getChapters(sno, uname, topic) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TopicProgress(sno, uname, topic),
    ));
  }
}

class ChapterModel {
  String sno;
  String chapterName;
  List topics;
  int totalChapterTopic;
  int completedTopicByUser;

  ChapterModel({this.sno, this.chapterName, this.topics, this.completedTopicByUser, this.totalChapterTopic});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    chapterName = json['chapterName'];
    totalChapterTopic = json['totalChapterTopic'];
    completedTopicByUser = json['completedTopicByUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['chapterName'] = this.chapterName;
    data['totalChapterTopic'] = this.totalChapterTopic;
    data['completedTopicByUser'] = this.completedTopicByUser;
    return data;
  }
}
