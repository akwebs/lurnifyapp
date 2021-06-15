import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myProgress/TopicProgress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChapterProgress extends StatefulWidget {
  final sno;
  final String uname;
  ChapterProgress(this.sno, this.uname);
  @override
  _ChapterProgressState createState() => _ChapterProgressState(sno, uname);
}

class _ChapterProgressState extends State<ChapterProgress> {
  final sno;
  final String uname;
  _ChapterProgressState(this.sno, this.uname);
  List _myChapterProgress;

  Future _getMyChapterProgress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String registrationSno = sp.getString("studentSno");
    var url = baseUrl +
        "getChapterProgressByUnit?registrationSno=" +
        registrationSno +
        "&unitSno=" +
        sno.toString();
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _myChapterProgress = resbody;
    print(_myChapterProgress);
  }

  @override
  void initState() {
    _myChapterProgress = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMyChapterProgress(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: Container(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(uname + ' Progress'),
                  centerTitle: true,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.yellow],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: ListView.builder(
                itemCount: _myChapterProgress.length,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  double percent = _myChapterProgress[i]
                          ['userCompletedTopics'] /
                      _myChapterProgress[i]['totalTopics'];
                  double completedChapter = (_myChapterProgress[i]
                          ['userCompletedTopics'] /
                      _myChapterProgress[i]['totalTopics'] *
                      100);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: AspectRatio(
                      aspectRatio: 4 / 1,
                      child: InkWell(
                        onTap: () {
                          _getTopics(_myChapterProgress[i]['chapterSno'],
                              _myChapterProgress[i]['chapterName']);
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
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
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        6 /
                                        10,
                                    child: Text(
                                      _myChapterProgress[i]['chapterName'],
                                      style: TextStyle(color: whiteColor),
                                    ),
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
                                      completedChapter > 100
                                          ? 100.toString()
                                          : completedChapter.toStringAsFixed(2),
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(30, 255, 255, 255),
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

  _getTopics(sno, cname) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TopicProgress(sno, cname),
    ));
  }
}
