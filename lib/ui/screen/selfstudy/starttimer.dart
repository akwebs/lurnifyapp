import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/helper/helper.dart';
import 'package:lurnify/model/model.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/screen.dart';
import 'package:lurnify/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class StartTimer extends StatefulWidget {
  final course, subject, unit, chapter, topic, subtopic, duration;

  StartTimer(this.course, this.subject, this.unit, this.chapter, this.topic,
      this.subtopic, this.duration);

  @override
  _StartTimerState createState() => _StartTimerState(
      course, subject, unit, chapter, topic, subtopic, duration);
}

class _StartTimerState extends State<StartTimer> {
  String course, subject, unit, chapter, topic, subtopic, duration;

  _StartTimerState(this.course, this.subject, this.unit, this.chapter,
      this.topic, this.subtopic, this.duration);

  double _height;
  double _width;
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
  int _topicTestTime=0;

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
      TestMainRepo testMainRepo = new TestMainRepo();
      List<Map<String, dynamic>> list =
          await testMainRepo.getTestMainByChapter(chapter);
      if (list.isEmpty) {
        var url3 = baseUrl + "getTestByChapter?chapterSno=" + chapter;
        print(url3);
        http.Response response2 = await http
            .post(
              Uri.encodeFull(url3),
            )
            .timeout(Duration(seconds: 1800));
        print('request done');
        testMain = (jsonDecode(response2.body) as List)
            .map((e) => TestMain.fromJson(e))
            .toList();

        DBHelper dbHelper = new DBHelper();
        Database db = await dbHelper.database;
        await db.transaction((txn) async {
          for (var a in testMain) {
            InstructionRepo instructionRepo = new InstructionRepo();
            instructionRepo.insertIntoInstruction(a.instruction, txn);
            print("Instruction Inserted");

            InstructionDataRepo instructionDataRepo = new InstructionDataRepo();
            for (var b in a.instruction.instructionData) {
              instructionDataRepo.insertIntoInstructionData(
                  b, a.instruction.sno.toString(), txn);
              print("Instruction Data Inserted");
            }

            TestMainRepo testMainRepo = new TestMainRepo();
            testMainRepo.insertIntoTestMain(a, txn);
            print("TestMain Inserted");

            for (var c in a.test) {
              TestRepo testRepo = new TestRepo();
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
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Press Again if you want to EXIT',
          toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    final lastPressString = null;
    _lastButtonPress = lastPressString != null
        ? DateTime.parse(lastPressString)
        : DateTime.now();
    _updateTimer();
    _ticker = Timer.periodic(Duration(seconds: 1), (_) {
      _updateTimer();
      calculateTimeInSeconds();
    });
    _ticker2 = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        remainingDuration = remainingDuration - 1;
        if (remainingDuration > 0) {
          remainingMessage = Duration(seconds: remainingDuration.round())
                  .inMinutes
                  .toString() +
              " min to complete the topic";
        } else {
          remainingMessage = Duration(seconds: remainingDuration.round())
                  .inMinutes
                  .toString() +
              " min taking more.";
        }
      });
    });
    _ticker3 = Timer.periodic(Duration(seconds: BEEP_SOUND_DURATION), (_) {
      if (sound == "sound") {
        AudioCache player = new AudioCache();
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

  Future _getHeading() async {
    try {
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // var url3 = baseUrl +
      //     "getTimerPageMessage?registerSno=" +
      //     sp.getString("studentSno") +
      //     "&topicSno=" +
      //     topic;
      // print(url3);
      // http.Response response2 = await http.get(
      //   Uri.encodeFull(url3),
      // );
      // var resbody2 = jsonDecode(response2.body);
      // heading = resbody2;
      // List tempHead = heading['timepageMessage'];
      // headingList = [];
      // for (int i = 0; i < tempHead.length; i++) {
      //   headingList
      //       .add(utf8.decode(tempHead[i]['message'].toString().runes.toList()));
      // }
      // sum = double.parse(heading['totalSecondByRegistrationAndTopic']);
      DBHelper dbHelper = new DBHelper();
      List<Map<String, dynamic>> list =
          await dbHelper.getTimerPageMessage(topic);
      for (var a in list) {
        int totalSecond = a['totalSecond'] ?? 0;
        _alreadyStudiedTime = totalSecond.toDouble();
      }

      print("_alreadyStudiedTime $_alreadyStudiedTime");
      TestMainRepo testMainRepo = new TestMainRepo();
      List<Map<String,dynamic>> list2=await testMainRepo.findByTopic(topic);
      for(var a in list2){
        print("---------------------------------${a['topicTestTime']}");
        _topicTestTime=int.tryParse(a['topicTestTime']) ?? 0;
        _topicTestTime=_topicTestTime ;
      }
      if(_topicTestTime==0){
        _topicTestTime=20;
      }
      print("_topicTestTime $_topicTestTime");
      PaceRepo paceRepo = new PaceRepo();
      List<Map<String,dynamic>> list3=await paceRepo.getPace();
      double percentDifference=0;
      for(var a in list3){
        print("---------------------------------${a['percentDifference']}");
        percentDifference=double.tryParse(a['percentDifference']) ?? 0;
      }
      print("percentDifference $percentDifference");
      double convertedDuration=double.tryParse(duration) ?? 0;
      duration =(convertedDuration+(convertedDuration*percentDifference/100)-_topicTestTime).round().toString();

      calculateRemainingDuration();
    } catch (e) {
      print(e);
    }
  }

  void calculateRemainingDuration() {
    getDatesForDateRow();
    remainingDuration =
        Duration(minutes: double.parse(duration).round()).inSeconds - _alreadyStudiedTime;
    if (remainingDuration > 0) {
      remainingMessage =
          Duration(seconds: remainingDuration.round()).inMinutes.toString() +
              " min to complete the topic";
    } else {
      remainingMessage =
          Duration(seconds: remainingDuration.round()).inMinutes.toString() +
              " min taking more.";
    }
  }

  void getDatesForDateRow() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    totalWeeks = sp.getInt("totalWeeks").toString();
    int completedDays = DateTime.now()
        .difference(DateTime.parse(sp.getString("firstMonday")))
        .inDays;
    int remainingDays =
        DateTime.parse(sp.getString("firstMonday"))
            .difference(DateTime.now())
            .inDays;
    if (remainingDays <= 100) {
      leftDaysOrWeek = remainingDays.toString() + "Days left";
    } else {
      leftDaysOrWeek = ((completedDays / 7).round() + 1).toString() +
          "/" +
          totalWeeks +
          " Weeks";
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            actionsIconTheme: IconThemeData(color: whiteColor),
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   onPressed: () => Navigator.pop(context),
            // ),
            title: Text(
              'Study Timer',
              style: TextStyle(color: whiteColor),
            ),
            actions: [
              IconButton(
                icon: sound == "sound"
                    ? Icon(
                        Icons.volume_up,
                      )
                    : Icon(
                        Icons.volume_off,
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
              ),
              IconButton(
                icon: Icon(Icons.help),
                onPressed: () {
                  questionAlertBox(context);
                },
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: FutureBuilder(
              future: data,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: _height,
                    width: _width,
                    margin:
                        EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: _width,
                          padding: EdgeInsets.all(10),
                          child: FadeAnimatedTextKit(
                            onTap: () {},
                            text: headingList.isEmpty ||
                                    headingList.length < 1 ||
                                    headingList == null
                                ? ["Welcome To Lurnify"]
                                : headingList,
                            textStyle: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                            alignment: AlignmentDirectional.center,
                            repeatForever: true,
                            // or Alignment.topLeft
                            duration: Duration(seconds: 3),
                          ),
                        ),
                        SizedBox(
                          height: _height / 22,
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          child: Text('Beat Distraction'),
                          onPressed: () => beatDistraction(),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                        ),
                        Container(
                          height: _height / 2.2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              child: Column(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    onPressed: () => showSubTopic(context),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Studying Topic-1",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: whiteColor)),
                                  ),
                                  SizedBox(
                                    width: _width,
                                    height: _height / 4,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: firstColor),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              dateRow(),
                                              Spacer(),
                                              Center(
                                                  child: Text(
                                                _pressDuration,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2,
                                              )),
                                              Spacer(),
                                            ],
                                          ),
                                        )),
                                  ),
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    onPressed: () => remainingAlertBox(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          remainingMessage,
                                          style: TextStyle(
                                            color: remainingDuration < 0
                                                ? Colors.red
                                                : Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height / 10,
                        ),
                        // Container(
                        //     alignment: Alignment.bottomCenter,
                        //     width: _width,
                        //     padding: EdgeInsets.all(10),
                        //     child: Row(
                        //       children: [
                        //         IconButton(
                        //           icon: sound == "sound"
                        //               ? Icon(
                        //                   Icons.volume_up,
                        //                 )
                        //               : Icon(
                        //                   Icons.volume_off,
                        //                 ),
                        //           onPressed: () {
                        //             setState(() {
                        //               if (sound == "sound") {
                        //                 sound = "mute";
                        //               } else {
                        //                 sound = "sound";
                        //               }
                        //             });
                        //           },
                        //         ),
                        //         Spacer(),
                        //         GestureDetector(
                        //             onTap: () {
                        //               questionAlertBox(context);
                        //             },
                        //             child: Icon(
                        //               Icons.help,
                        //             ))
                        //       ],
                        //     )),
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
          ),
          bottomNavigationBar: Container(
            child: TextButton(
              child: Text(
                'END',
                style: TextStyle(fontSize: 30, color: whiteColor),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) => 3.0,
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) => Colors.red,
                ),
                overlayColor: MaterialStateProperty.all(Colors.black26),
              ),
              onPressed: () => endSession(),
            ),
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
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 24),
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
          builder: (context) => StudyComplete(
              _pressDuration,
              second.toString(),
              startDate,
              endDate,
              course,
              subject,
              unit,
              chapter,
              topic,
              duration),
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
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: 1),
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
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
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
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
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
