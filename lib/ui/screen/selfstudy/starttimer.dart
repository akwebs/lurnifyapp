import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/selfstudy/studycomplete.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  calculateTimeInSeconds() {
    second = second + 1;
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
  double sum = 0;
  String remainingMessage = "";

  Future _getHeading() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url3 = baseUrl +
          "getTimerPageMessage?registerSno=" +
          sp.getString("studentSno") +
          "&topicSno=" +
          topic;
      print(url3);
      http.Response response2 = await http.get(
        Uri.encodeFull(url3),
      );
      var resbody2 = jsonDecode(response2.body);
      heading = resbody2;
      List tempHead = heading['timepageMessage'];
      headingList = [];
      for (int i = 0; i < tempHead.length; i++) {
        headingList
            .add(utf8.decode(tempHead[i]['message'].toString().runes.toList()));
      }
      sum = double.parse(heading['totalSecondByRegistrationAndTopic']);
      calculateRemainingDuration();
    } catch (e) {
      print(e);
    }
  }

  void calculateRemainingDuration() {
    getDatesForDateRow();
    remainingDuration =
        Duration(minutes: double.parse(duration).round()).inSeconds - sum;
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
        .difference(DateTime.parse(sp.getString("courseStartingDate")))
        .inDays;
    int remainingDays =
        DateTime.parse(sp.getString("courseCompletionDateFormatted"))
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
    return Scaffold(
        body: FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Material(
            child: Container(
              height: _height,
              width: _width,
              margin: EdgeInsets.only(top: 28, left: 0, right: 0, bottom: 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[100]),
                  color: Colors.black87),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1, color: Colors.blue[100])),
                      ),
                      child: FadeAnimatedTextKit(
                        onTap: () {},
                        text: headingList.isEmpty ||
                                headingList.length < 1 ||
                                headingList == null
                            ? ["Welcome To Lurnify"]
                            : headingList,
                        textStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Canterbury",
                            color: Colors.white),
                        textAlign: TextAlign.start,
                        alignment: AlignmentDirectional.center,
                        repeatForever: true,
                        // or Alignment.topLeft
                        duration: Duration(seconds: 3),
                      ),
                    ),
                    SizedBox(
                      height: _height / 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        beatDistraction();
                      },
                      child: Container(
                          height: 70,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            border: Border.all(color: Colors.blue[100]),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 7, left: 8, right: 8, bottom: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.white),
                                  color: Colors.green),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Beat",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13),
                                  ),
                                  Text(
                                    "Distraction",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    Container(
                      height: _height / 2.2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showSubTopic(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(9),
                                          topRight: Radius.circular(9))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Studying Topic-1",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Center(
                                child: Container(
                                    height: 100,
                                    width: _width / 1.5,
                                    decoration: BoxDecoration(
                                        color: Colors.cyan[100],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        dateRow(),
                                        Center(
                                            child: Text(
                                          _pressDuration,
                                          style: TextStyle(fontSize: 50),
                                        )),
                                      ],
                                    )),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  remainingAlertBox();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(9),
                                          bottomRight: Radius.circular(9))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_up,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        remainingMessage,
                                        style: TextStyle(
                                            color: remainingDuration < 0
                                                ? Colors.red
                                                : Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 70,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          border: Border.all(color: Colors.blue[100]),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 25, left: 10, right: 10, bottom: 7),
                          child: GestureDetector(
                            onTap: () {
                              endSession();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.white),
                                  color: Colors.red),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "END",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: _height / 8,
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        width: _width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1, color: Colors.blue[100])),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: sound == "sound"
                                  ? Icon(
                                      Icons.volume_up,
                                      color: Colors.white54,
                                      size: 30,
                                    )
                                  : Icon(
                                      Icons.volume_off,
                                      color: Colors.white54,
                                      size: 30,
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
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  questionAlertBox(context);
                                },
                                child: Icon(
                                  Icons.help,
                                  color: Colors.white54,
                                  size: 30,
                                ))
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        }
      },
    ));
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
                backgroundColor: Colors.orangeAccent,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Study Help",
                  style: TextStyle(color: Colors.white),
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
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 24),
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
        pageBuilder: (context, animation1, animation2) {});
  }

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
                backgroundColor: Colors.orangeAccent,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Study Help",
                  style: TextStyle(color: Colors.white),
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
                              color: Colors.white,
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
                backgroundColor: Colors.orangeAccent,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Your Sub-Topics",
                  style: TextStyle(color: Colors.white),
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
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14),
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
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget dateRow() {
    return Container(
      padding: EdgeInsets.all(3),
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
                backgroundColor: Colors.orangeAccent,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  "Dont Worry!",
                  style: TextStyle(color: Colors.white),
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
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14),
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
        pageBuilder: (context, animation1, animation2) {});
  }
}
