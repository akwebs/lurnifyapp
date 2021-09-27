import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/selfstudy/timer_page.dart';
import '../../../helper/db_helper.dart';
import '../../../helper/recent_study_repo.dart';
import 'start_timer.dart';
import 'sync_your_time.dart';
import '../../../widgets/componants/custom_button.dart';
import '../../constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'content_select.dart';

class Recent extends StatefulWidget {
  final String pageKey;
  Recent(this.pageKey);
  @override
  _RecentState createState() => _RecentState(pageKey);
}

class _RecentState extends State<Recent> {
  String pageKey;
  _RecentState(this.pageKey);
  List<Map<String, dynamic>> recentData = [];
  List nextData = [];
  bool lastTopicResult = false;
  var data;
  get fullWidth => Responsive.getPercent(100, ResponsiveSize.WIDTH, context);
  Future _getRecentData() async {
    try {
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +
      //     "getRecentStudy?registrationSno=" +
      //     sp.getString("studentSno");
      // print(url);
      // http.Response response = await http.get(
      //   Uri.encodeFull(url),
      // );
      // var resbody = jsonDecode(response.body);
      // recentData = resbody;
      RecentStudyRepo recentStudyRepo = new RecentStudyRepo();
      recentData = await recentStudyRepo.getRecentStudy();
      print(recentData);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    data = _getRecentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _title;
    String _fabText;
    if (pageKey == "1") {
      _title = 'Self Study Section';
      _fabText = 'Start Study';
    } else if (pageKey == "2") {
      _title = 'Sync your Study';
      _fabText = 'Sync Study';
    } else if (pageKey == "3") {
      _title = 'Goals';
      _fabText = 'Sync Study';
    }

    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return [sHistory(context, _width)].vStack().scrollVertical();
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
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        buttonText: _fabText,
        verpad: const EdgeInsets.symmetric(vertical: 5),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ContentSelect(pageKey),
          ),
        ),
      ),
    );
  }

  Widget sHistory(context, _width) {
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return recentData == null
        ? Container()
        : ListView.builder(
            itemCount: recentData.length,
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              String subTopic = recentData[i]['subTopic'];
              String lastSudied = recentData[i]['enteredDate'];
              DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(lastSudied);
              return [
                [
                  Text(recentData[i]['subjectName']).text.lg.semiBold.make(),
                  const Spacer(),
                  recentData[i]['studyType'] != "Complete"
                      ? const Icon(
                          Icons.pending_actions,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                        ),
                ].hStack().p8().box.color(randomColor(i)).make(),
                [
                  Text(
                    "Chapter : " + recentData[i]['chapterName'],
                  ).text.semiBold.make().p8(),
                  [
                    Text(
                      recentData[i]['topicName'] + " :  ",
                    ),
                    VxBox(
                      child: recentData[i]['subTopic'] == null ? "".text.make() : subTopic.text.make().w64(context),
                    ).make(),
                  ].hStack(crossAlignment: CrossAxisAlignment.start).p8(),
                  8.heightBox,
                  [
                    recentData[i]['studyType'] != "Complete"
                        ? TextButton(
                            onPressed: () {
                              String subjectSno = recentData[i]['subjectSno'].toString();
                              String unitSno = recentData[i]['unitSno'].toString();
                              String chapterSno = recentData[i]['chapterSno'].toString();
                              String topicSno = recentData[i]['topicSno'].toString();
                              String subTopic = recentData[i]['subTopic'].toString();
                              String duration = recentData[i]['duration'].toString();
                              //print("---------------1" + duration);
                              _goToNextScreen(subjectSno, unitSno, chapterSno, topicSno, subTopic, duration);
                            },
                            child: const Text('Start Study'),
                          )
                        : TextButton(
                            onPressed: () {
                              String subjectSno = recentData[i]['subjectSno'].toString();
                              String subjectName = recentData[i]['subjectName'].toString();
                              String unitSno = recentData[i]['unitSno'].toString();
                              String unitName = recentData[i]['unitName'].toString();
                              String chapterSno = recentData[i]['chapterSno'].toString();
                              String chapterName = recentData[i]['chapterName'].toString();
                              String topicSno = recentData[i]['topicSno'].toString();
                              _getNextTopic(subjectSno, subjectName, unitSno, unitName, chapterSno, chapterName, topicSno);
                            },
                            child: const Text(
                              "Study Next Topic",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                  ].hStack(alignment: MainAxisAlignment.end).wFull(context),
                  [
                    const Text(
                      "Last Studied : ",
                    ).text.sm.color(Vx.black).make(),
                    Text(
                      tempDate.timeAgo(),
                    ).text.sm.color(Vx.black).make(),
                  ].hStack(alignment: MainAxisAlignment.spaceBetween).wFull(context).box.p4.color(Vx.blue100).make(),
                ].vStack(crossAlignment: CrossAxisAlignment.start),
              ]
                  .vStack(crossAlignment: CrossAxisAlignment.start)
                  .box
                  .withGradient(
                    LinearGradient(
                      colors: [Colors.cyan[200].withOpacity(0.1), Colors.purple[200].withOpacity(0.1)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  )
                  .make()
                  .card
                  .elevation(5)
                  .make()
                  .px8()
                  .py4();
            });
  }

  _goToNextScreen(subjectSno, unitSno, chapterSno, topicSno, subTopic, duration) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String course = sp.getString("courseSno");
    print("---------------2" + duration);
    if (pageKey == "1") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TimerPage(course, subjectSno, unitSno, chapterSno, topicSno, subTopic, duration)));
    } else if (pageKey == "2") {
      print("---------------3" + duration);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SyncYourTime(course, subjectSno, unitSno, chapterSno, topicSno, duration)));
    }
  }

  Future _getNextTopic(subjectSno, subjectName, unitSno, unitName, chapterSno, chapterName, topicSno) async {
    try {
      // var url = baseUrl +
      //     "getNextTopic?chapterSno=" +
      //     chapterSno +
      //     "&topicSno=" +
      //     topicSno +
      //     "";
      // print(url);
      // http.Response response = await http.get(
      //   Uri.encodeFull(url),
      // );
      // print(url);
      // var resbody = jsonDecode(response.body);
      // nextData = resbody;
      DBHelper dbHelper = new DBHelper();
      print("111111-------------------" + topicSno);
      nextData = await dbHelper.getNextTopic(chapterSno, topicSno);
      print(nextData);
      if (nextData.isEmpty) {
        lastTopicResult = true;
        print(lastTopicResult);
        noTopicAlertBox();
      } else {
        lastTopicResult = false;
        print(lastTopicResult);
        topicAlertBox(subjectSno, subjectName, unitSno, unitName, chapterSno, chapterName, nextData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future topicAlertBox(subjectSno, subjectName, unitSno, unitName, chapterSno, chapterName, nextData) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.white70,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(color: Colors.cyanAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "'" + nextData[0]['topicName'] + "'" + " is Your Next Topic. Do you want to study?",
                                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 16),
                                    )),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Subject Name : " + subjectName,
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                            )),
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Unit Name : " + unitName,
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                            )),
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Subject Name : " + subjectName,
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text(
                                    "Topic Name : " + nextData[0]['topicName'],
                                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  "SubTopic Name : " + nextData[0]['subTopic'],
                                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text(
                                "START",
                                style: TextStyle(color: Colors.black87),
                              ),
                              onPressed: () {
                                nextTopicStart(subjectSno, unitSno, chapterSno, nextData[0]['sno'].toString(), nextData[0]['subTopic'], nextData[0]['duration']);
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  Future noTopicAlertBox() {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.white70,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                content: SizedBox(
                    height: 300,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          decoration: const BoxDecoration(color: Colors.cyanAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Congratulations! You have completed all the topics of this chapter. Please Select another chapter.",
                                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 16),
                                    )),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  nextTopicStart(subjectSno, unitSno, chapterSno, topicSno, subTopic, duration) {
    Navigator.of(context).pop();
    if (pageKey == "1") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartTimer("1", subjectSno, unitSno, chapterSno, topicSno, subTopic, duration)));
    } else if (pageKey == "2") {
      print("---------------" + duration);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SyncYourTime("1", subjectSno, unitSno, chapterSno, topicSno, duration)));
    }
  }
}
