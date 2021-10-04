// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../widgets/componants/custom_button.dart';
import '../../../helper/db_helper.dart';
import '../../../helper/instruction_repo.dart';
import '../../../helper/instruction_repo_data.dart';
import '../../../helper/pace_repo.dart';
import '../../../helper/test_main_repo.dart';
import '../../../helper/test_repo.dart';
import '../../../model/test_main.dart';
import '../../constant/ApiConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:velocity_x/velocity_x.dart';

import 'package:sqflite/sqflite.dart';

import 'study_complete.dart';

class TimerPage extends StatefulWidget {
  final course, subject, unit, chapter, topic, subtopic, duration;

  const TimerPage(this.course, this.subject, this.unit, this.chapter, this.topic, this.subtopic, this.duration, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  // course, subject, unit, chapter, topic, subtopic, duration
  _TimerPageState createState() => _TimerPageState(course, subject, unit, chapter, topic, subtopic, duration);
}

class _TimerPageState extends State<TimerPage> {
  String course, subject, unit, chapter, topic, subtopic, duration;
//
  _TimerPageState(this.course, this.subject, this.unit, this.chapter, this.topic, this.subtopic, this.duration);

  var data;
  DateTime _lastButtonPress;
  String _pressDuration;
  Timer _ticker;
  Timer _ticker2;
  Timer _ticker3;
  double remainingDuration = 0;
  int second = 0;
  String sound = "sound";
  String startDate = DateTime.now().toString().split("\.")[0];
  String weekDay = DateTime.now().weekday.toString();
  String totalWeeks = "";
  String leftDaysOrWeek = "";
  int BEEP_SOUND_DURATION = 600;
  int _topicTestTime = 0;
  bool isDark = false;
  Color color;
  Color textColor;
  String bgImg;
  var value;

  void _updateTimer() {
    final duration = DateTime.now().difference(_lastButtonPress);
    final newDuration = _formatDuration(duration);
    setState(() {
      _pressDuration = newDuration;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String oneDigits(int n) {
      if (n <= 9) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${oneDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  calculateTimeInSeconds() async {
    second = second + 1;

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('lastStudyTime', second);

    List<TestMain> testMain = [];
    if (second == 10) {
      TestMainRepo testMainRepo = TestMainRepo();
      List<Map<String, dynamic>> list = await testMainRepo.getTestMainByChapter(chapter);
      if (list.isEmpty) {
        var url3 = baseUrl + "getTestByChapter?chapterSno=" + chapter;
        print(url3);
        http.Response response2 = await http
            .post(
              Uri.encodeFull(url3),
            )
            .timeout(const Duration(seconds: 1800));
        print('request done');
        testMain = (jsonDecode(response2.body) as List).map((e) => TestMain.fromJson(e)).toList();

        DBHelper dbHelper = DBHelper();
        Database db = await dbHelper.database;
        await db.transaction((txn) async {
          for (var a in testMain) {
            InstructionRepo instructionRepo = InstructionRepo();
            instructionRepo.insertIntoInstruction(a.instruction, txn);
            print("Instruction Inserted");

            InstructionDataRepo instructionDataRepo = InstructionDataRepo();
            for (var b in a.instruction.instructionData) {
              instructionDataRepo.insertIntoInstructionData(b, a.instruction.sno.toString(), txn);
              print("Instruction Data Inserted");
            }

            TestMainRepo testMainRepo = TestMainRepo();
            testMainRepo.insertIntoTestMain(a, txn);
            print("TestMain Inserted");

            for (var c in a.test) {
              TestRepo testRepo = TestRepo();
              c.testMain = a.sno.toString();
              testRepo.insertIntoTest(c, txn);
              print("Test Inserted");
            }
          }
        });
      }
    }
  }

  DateTime _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press Again if you want to EXIT', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    final lastPressString = null;
    _lastButtonPress = lastPressString != null ? DateTime.parse(lastPressString) : DateTime.now();
    _updateTimer();
    _ticker = Timer.periodic(Duration(seconds: 1), (_) {
      _updateTimer();
      calculateTimeInSeconds();
    });
    _ticker2 = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        remainingDuration = remainingDuration - 1;
        if (remainingDuration > 0) {
          remainingMessage = Duration(seconds: remainingDuration.round()).inMinutes.toString() + " min to complete";
        } else {
          remainingMessage = Duration(seconds: remainingDuration.round()).inMinutes.toString() + " min taking more.";
        }
      });
    });
    _ticker3 = Timer.periodic(Duration(seconds: BEEP_SOUND_DURATION), (_) {
      if (sound == "sound") {
        AudioCache player = AudioCache();
        const alarmAudioPath = "audio/beep.mp3";
        player.play(alarmAudioPath);
      }
    });
    data = _getHeading();
  }

  @override
  void dispose() {
    _ticker.cancel();
    _ticker2.cancel();
    _ticker3.cancel();
    super.dispose();
  }

  Map<String, dynamic> heading;
  List<String> headingList = [];
  double _alreadyStudiedTime = 0;
  String remainingMessage = "";
  int alreadyStudied = 0;
  Future _getHeading() async {
    try {
      DBHelper dbHelper = DBHelper();
      List<Map<String, dynamic>> list = await dbHelper.getTimerPageMessage(topic);
      for (var a in list) {
        int totalSecond = a['totalSecond'] ?? 0;
        _alreadyStudiedTime = totalSecond.toDouble();
      }

      print("_alreadyStudiedTime $_alreadyStudiedTime");
      TestMainRepo testMainRepo = TestMainRepo();
      List<Map<String, dynamic>> list2 = await testMainRepo.findByTopic(topic);
      for (var a in list2) {
        print("---------------------------------${a['topicTestTime']}");
        _topicTestTime = int.tryParse(a['topicTestTime']) ?? 0;
        _topicTestTime = _topicTestTime;
      }
      if (_topicTestTime == 0) {
        _topicTestTime = 20;
      }
      print("_topicTestTime $_topicTestTime");
      PaceRepo paceRepo = PaceRepo();
      List<Map<String, dynamic>> list3 = await paceRepo.getPace();
      double percentDifference = 0;
      for (var a in list3) {
        print("---------------------------------${a['percentDifference']}");
        percentDifference = double.tryParse(a['percentDifference']) ?? 0;
      }
      print("percentDifference $percentDifference");
      double convertedDuration = double.tryParse(duration) ?? 0;
      duration = (convertedDuration + (convertedDuration * percentDifference / 100) - _topicTestTime).round().toString();

      calculateRemainingDuration();
    } catch (e) {
      print(e);
    }
  }

  void calculateRemainingDuration() {
    getDatesForDateRow();
    alreadyStudied = Duration(seconds: double.parse(_alreadyStudiedTime.toString()).round()).inMinutes;
    remainingDuration = Duration(minutes: double.parse(duration).round()).inSeconds - _alreadyStudiedTime;
    if (remainingDuration > 0) {
      remainingMessage = Duration(seconds: remainingDuration.round()).inMinutes.toString() + " min to complete the topic";
    } else {
      remainingMessage = Duration(seconds: remainingDuration.round()).inMinutes.toString() + " min taking more.";
    }
  }

  void getDatesForDateRow() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    totalWeeks = sp.getInt("totalWeeks").toString();
    int completedDays = DateTime.now().difference(DateTime.parse(sp.getString("firstMonday"))).inDays;
    int remainingDays = DateTime.parse(sp.getString("firstMonday")).difference(DateTime.now()).inDays;
    if (remainingDays <= 30) {
      leftDaysOrWeek = remainingDays.toString() + " Days left";
    } else {
      leftDaysOrWeek = ((completedDays / 7).round() + 1).toString() + "/" + totalWeeks + " Weeks";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDark == true) {
      bgImg = "assets/bg/night_1.jpg";
      color = Vx.black;
      textColor = Vx.white;
      value = SystemUiOverlayStyle.light;
    } else {
      bgImg = "assets/bg/day_1.jpg";
      color = Vx.white;
      textColor = Vx.black;
      value = SystemUiOverlayStyle.dark;
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: value,
        child: Scaffold(
          extendBody: true,
          body: FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return [
                  VxBox(
                    child: [
                      [
                        "Studied $alreadyStudied Min".text.xl.semiBold.color(firstColor).make(),
                        10.heightBox,
                        _pressDuration.text.semiBold.xl5.color(textColor).make(),
                        10.heightBox,
                        remainingMessage.text.semiBold.color(Vx.red500).make(),
                      ].vStack().box.shadowMd.roundedFull.p64.color(color.withOpacity(0.8)).make(),
                      // CircularPercentIndicator(
                      //   radius: 260,
                      //   percent: 1.0,
                      //   progressColor: Vx.randomColor,
                      //   lineWidth: 5,
                      // )
                    ].zStack(alignment: Alignment.center).centered(),
                  ).bgImage(DecorationImage(image: AssetImage(bgImg), fit: BoxFit.cover)).make().whFull(context),
                  SafeArea(
                    child: [
                      [
                        IconButton(
                          icon: sound == "sound"
                              ? Icon(
                                  Icons.volume_up,
                                  color: textColor,
                                )
                              : Icon(
                                  Icons.volume_off,
                                  color: textColor,
                                ),
                          onPressed: () {
                            setState(() {
                              if (sound == "sound") {
                                sound = "mute";
                              } else {
                                sound = "sound";
                              }
                            });
                          },
                        ).box.roundedFull.shadowMd.color(color).make(),
                        const Spacer(),
                        IconButton(
                          icon: isDark == false
                              ? Icon(
                                  Icons.brightness_4,
                                  color: textColor,
                                )
                              : Icon(
                                  Icons.brightness_2,
                                  color: textColor,
                                ),
                          onPressed: () {
                            setState(() {
                              if (isDark == false) {
                                setState(() {
                                  isDark = true;
                                });
                              } else {
                                setState(() {
                                  isDark = false;
                                });
                              }
                            });
                          },
                        ).box.roundedFull.shadowMd.color(color).make(),
                      ].hStack(alignment: MainAxisAlignment.spaceBetween).p8(),
                      [
                        'Week : 1 / 20'.text.semiBold.color(textColor).make(),
                        const Spacer(),
                        'Day 4'.text.semiBold.color(textColor).make(),
                      ].hStack().px8().box.p12.color(color.withOpacity(0.8)).make().py16(),
                      [
                        FadeAnimatedTextKit(
                          onTap: () {},
                          text: headingList.isEmpty || headingList == null ? ["Welcome To Lurnify"] : headingList,
                          textStyle: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                          alignment: AlignmentDirectional.center,
                          repeatForever: true,
                          // or Alignment.topLeft
                          duration: const Duration(seconds: 3),
                        ).wFull(context),
                      ].hStack(),
                      const HeightBox(10).hHalf(context),
                      [
                        FadeAnimatedTextKit(
                          onTap: () {},
                          text: const ["Remaining 64 Days", "Remaining 10 Weeks"],
                          textStyle: TextStyle(color: textColor, fontSize: Vx.dp16),
                          textAlign: TextAlign.center,
                          alignment: AlignmentDirectional.center,
                          repeatForever: true,
                          // or Alignment.topLeft
                          duration: const Duration(seconds: 5),
                        ).wFull(context),
                      ].hStack().box.py12.color(color.withOpacity(0.8)).make(),
                    ].vStack(),
                  ),
                ].zStack();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          bottomNavigationBar: CustomButton(
            btnClr: color,
            buttonText: "END",
            color: Vx.red500,
            fntWgt: FontWeight.w600,
            fntSize: Vx.dp20,
            brdRds: 0,
            verpad: const EdgeInsets.symmetric(vertical: 5),
            onPressed: () {
              endSession();
            },
          ),
        ),
      ),
    );
  }

  Future questionAlertBox(context) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Study Help",
                  textAlign: TextAlign.center,
                ),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Here will some subtopics and data for study help",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                        )
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

  // ignore: missing_return
  Future endSession() {
    _ticker.cancel();
    String endDate = DateTime.now().toString().split("\.")[0];
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudyComplete(_pressDuration, second.toString(), startDate, endDate, course, subject, unit, chapter, topic, duration),
        ));
  }

  Future beatDistractionAlertBox(context, String message) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Study Help",
                  textAlign: TextAlign.center,
                ),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          message,
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1),
                        )
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

  Future beatDistraction() async {
    String message = "";
    var url3 = baseUrl + "getBeatDistraction";
    http.Response response2 = await http.get(
      Uri.encodeFull(url3),
    );
    var resbody2 = jsonDecode(response2.body);
    List response = resbody2;
    for (int i = 0; i < response.length; i++) {
      message = response[i]['message'];
    }
    beatDistractionAlertBox(context, message);
  }

  showSubTopic(context) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Your Sub-Topics",
                  textAlign: TextAlign.center,
                ),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          subtopic,
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        )
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

  Widget dateRow() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text("Day-$weekDay"), Spacer(), Text(leftDaysOrWeek)],
      ),
    );
  }

  remainingAlertBox() {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Dont Worry!",
                  textAlign: TextAlign.center,
                ),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Dont Worry if you taking more time. It is good to learn deep, not just completing the topic",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        )
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
}
