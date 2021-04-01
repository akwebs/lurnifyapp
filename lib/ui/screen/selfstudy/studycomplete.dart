import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/ui/screen/test/instructionPage.dart';
import 'package:material_switch/material_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudyComplete extends StatefulWidget {
  final time;
  final second;
  final startDate;
  final endDate;
  final course, subject, unit, chapter, topic, duration;
  StudyComplete(
      this.time,
      this.second,
      this.startDate,
      this.endDate,
      this.course,
      this.subject,
      this.unit,
      this.chapter,
      this.topic,
      this.duration);

  @override
  _StudyCompleteState createState() => _StudyCompleteState(time, second,
      startDate, endDate, course, subject, unit, chapter, topic, duration);
}

class _StudyCompleteState extends State<StudyComplete> {
  String time,
      second,
      startDate,
      endDate,
      course,
      subject,
      unit,
      chapter,
      topic,
      duration;

  _StudyCompleteState(
      this.time,
      this.second,
      this.startDate,
      this.endDate,
      this.course,
      this.subject,
      this.unit,
      this.chapter,
      this.topic,
      this.duration);

  List<String> switchOptions = ["Studying", "Complete"];
  String selectedSwitchOption = "Studying";
  TextEditingController remarkSubject = new TextEditingController();
  TextEditingController remarkMessage = new TextEditingController();
  List<String> switchOptions2 = ["Min", "Hr"];
  String selectedSwitchOption2 = "Min";
  var data;
  double hr = 1;
  int printHr = 0;
  int printMin = 0;
  String printTime = "00:00";
  double theoryOrNum = 0;
  double effectivenessOfStudy = 100;
  double min = 5;
  double totalStudyHour = 0;
  String leftStudyHour = "";
  String startStudyAfter = "";
  String totalDimeEarns = "";

  get fullWidth => Responsive.getPercent(100, ResponsiveSize.WIDTH, context);
  Future _getTotalSecondByDate() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl +
        "getTotalSecondByDate?date=" +
        startDate.split(" ")[0] +
        "&registrationSno=" +
        sp.getString("studentSno") +
        "&totalSeconds=" +
        second;
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    Map<String, dynamic> mapResult = resbody;
    String sum = mapResult['totalSecondByDate'].toString();
    totalDimeEarns = mapResult['totalDimeEarns'];
    if (totalDimeEarns == null) {
      totalDimeEarns = "0";
    }
    getLeftStudyHour(sum);
  }

  Future getLeftStudyHour(String sum) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    double lastStudySecond = 0;
    try {
      lastStudySecond = double.parse(sum);
    } catch (e) {
      lastStudySecond = 0;
    }
    totalStudyHour = sp.getDouble("totalStudyHour");
    int totalStudyHourInSeconds =
        Duration(hours: totalStudyHour.round()).inSeconds;
    double totalLefSecond =
        totalStudyHourInSeconds - int.parse(second) - lastStudySecond;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(
        Duration(seconds: totalLefSecond.toInt()).inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(
        Duration(seconds: totalLefSecond.toInt()).inSeconds.remainder(60));
    leftStudyHour =
        "${twoDigits(Duration(seconds: totalLefSecond.toInt()).inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    data = _getTotalSecondByDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Study Complete"),
          centerTitle: true,
        ),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
//                SizedBox(height: 8,),
                        completionNotice(),
                        secondRow(),
                        thirdRow(),
                        forthRow()
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }

  Widget completionNotice() {
    return Container(
      width: fullWidth,
      height: Responsive.getPercent(20, ResponsiveSize.HEIGHT, context),
      padding: EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(5),
                width: fullWidth,
                color: firstColor,
                child: Text(
                  "Congratulation!",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Spacer(),
            Flexible(
              flex: 1,
              child: Text(
                "You have earned $totalDimeEarns Dimes ",
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                leftStudyHour.length < 1 ? "0" : leftStudyHour,
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                "to complete today's study time",
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget secondRow() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Colors.amberAccent,
              ),
              child: Text(
                "Topic-1",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Topic : ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  Expanded(
                    child: MaterialSwitch(
                      selectedOption: selectedSwitchOption,
                      options: switchOptions,
                      selectedBackgroundColor: Colors.deepPurpleAccent,
                      selectedTextColor: Colors.white,
                      onSelect: (String selectedOption) {
                        setState(() {
                          selectedSwitchOption = selectedOption;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      remarkBox();
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          "Studied : ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Th",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.red[700],
                                inactiveTrackColor: Colors.red[100],
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: Colors.redAccent,
                                overlayColor: Colors.red.withAlpha(32),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.red[700],
                                inactiveTickMarkColor: Colors.red[100],
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.redAccent,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                value: theoryOrNum,
                                min: 0,
                                max: 100,
                                divisions: 20,
                                label: theoryOrNum.round().toString(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      theoryOrNum = value;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            "Num",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          "Effectiveness Of Study : ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "0%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.red[700],
                                inactiveTrackColor: Colors.red[100],
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: Colors.redAccent,
                                overlayColor: Colors.red.withAlpha(32),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.red[700],
                                inactiveTickMarkColor: Colors.red[100],
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.redAccent,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                value: effectivenessOfStudy,
                                min: 0,
                                max: 100,
                                divisions: 20,
                                label: effectivenessOfStudy.round().toString(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      effectivenessOfStudy = value;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            "100%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget thirdRow() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Colors.amberAccent,
              ),
              child: Text(
                "Continue Study After:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                      offset: Offset(1, 0)),
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "I will start my study at ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
//                      Text("$printHr Hours $printMin mins", style: TextStyle(
//                          fontSize: 14,
//                          fontWeight: FontWeight.w600,
//                          color: Colors.purple),),
                      Text(
                        startStudyAfter,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  height: MediaQuery.of(context).copyWith().size.height / 6,
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
//                      backgroundColor: Colors.white,
                      alignment: Alignment.center,
                      onTimerDurationChanged: (Duration changedtimer) {
                        setState(() {
                          var formatter = DateFormat("hh:mm a");
                          startStudyAfter = _printDuration(changedtimer);
                        });
                      })),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget forthRow() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        child: Center(
          child: ButtonTheme(
            minWidth: 150,
            child: RaisedButton(
              child: Text(
                "DONE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              color: Colors.amberAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(width: 1, color: Colors.deepPurpleAccent)),
              onPressed: () {
                _submitDone();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _submitDone() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String thOrNum = theoryOrNum.toString();
    String effectiveStudy = effectivenessOfStudy.toString();
    String hour = printHr.toString();
    String min = printMin.toString();
    String totalTime = time;
    String totalSecond = second;
    String studentSno = sp.getString("studentSno");
    String newEndDate = startDate.split(" ")[0] + "23:59:59";
    String newStartDate = "00:00:00" + endDate.split(" ")[0];
    try {
      var url = baseUrl +
          "saveStudy?registrationSno=" +
          studentSno +
          "&startDate=" +
          startDate +
          "&endDate=" +
          endDate +
          "&totalTime=" +
          totalTime +
          "&totalSecond=" +
          totalSecond +
          ""
              "&topicCompletionStatus=" +
          selectedSwitchOption +
          ""
              "&theoryPercent=" +
          thOrNum +
          ""
              "&numericalPercent=" +
          (100 - theoryOrNum).toString() +
          ""
              "&effectivenessOfStudy=" +
          effectiveStudy +
          ""
              "&courseSno=" +
          course +
          ""
              "&subjectSno=" +
          subject +
          ""
              "&unitSno=" +
          unit +
          ""
              "&chapterSno=" +
          chapter +
          ""
              "&topicSno=" +
          topic +
          ""
              "&date=" +
          startDate.split(" ")[0] +
          ""
              "&duration=" +
          duration +
          "&timePunchedFrom=TIMER";
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      print(resbody);
      Map<String, dynamic> mapResult = resbody;
      if (mapResult['saveResult'] == true) {
        toastMethod("Study Saved");
        if (selectedSwitchOption == "Complete") {
          _takeTestAlertBox(context);
        } else {
          Navigator.pop(context);
        }
      } else {
        toastMethod("failed");
      }
    } catch (e) {
      print(e);
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  void _setContinueStudyAfterTime() {
    var formatter = new DateFormat('hh:mm a');
    printTime = formatter.format(
        DateTime.now().add(Duration(hours: printHr, minutes: printMin)));
  }

  Future remarkBox() async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding: EdgeInsets.all(0),
                content: Container(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.cyanAccent),
                      child: Text(
                        "Add Remark",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Find Topics at someLocation",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.blue[100])),
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          controller: remarkSubject,
                          decoration: InputDecoration(
                              hintText: "Subject :",
                              isDense: true,
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.blue[100])),
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          controller: remarkMessage,
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: "Message : ",
                              isDense: true,
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.cyanAccent,
                      child: Text("Add"),
                      onPressed: () {
                        _addRemark();
                      },
                      splashColor: Colors.black54,
                    ),
                    SizedBox(
                      height: 20,
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
        pageBuilder: (context, animation1, animation2) {});
  }

  Future _addRemark() async {
    if (remarkSubject.text.length < 1) {
      toastMethod("Please Enter Subject For Refrence");
    } else if (remarkMessage.text.length < 1) {
      toastMethod("Please Enter Message");
    } else {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl +
          "saveRemark?subject=" +
          remarkSubject.text +
          "&message=" +
          remarkMessage.text +
          "&topicSno=" +
          topic +
          "&registrationSno=" +
          sp.getString("studentSno");
      print(url);
      http.Response response2 = await http.post(
        Uri.encodeFull(url),
      );
      var resbody2 = jsonDecode(response2.body);
      Map<String, dynamic> result = resbody2;
      if (result['result'].toString() == "true") {
        toastMethod("Remark Added");
        Navigator.of(context).pop();
      } else {
        toastMethod("Failed. Please Try Again");
      }
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  _takeTestAlertBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Congratulations! You have completed the topic.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          OutlineButton(
            child: Text("Take Test?"),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => InstructionPage(topic),
              ));
            },
          ),
          OutlineButton(
            child: Text("Not now"),
            onPressed: () {
//              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _acceptChallengeBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Congratulations! You have completed the last week challenge. Do you want to take next week challenge",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          OutlineButton(
            child: Text("Take Challenge?"),
            onPressed: () {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Test(topic,"topicTest",[]),));
            },
          ),
          OutlineButton(
            child: Text("Not now"),
            onPressed: () {
//              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
