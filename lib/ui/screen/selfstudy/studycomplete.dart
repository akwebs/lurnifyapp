import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/ui/screen/test/instructionPage.dart';
import 'package:lurnify/widgets/componants/custom-button.dart';
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
  bool _isStudyCompleted = false;
  // List<String> switchOptions = ["Studying", "Complete"];
  // String selectedSwitchOption = "Studying";
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
                      completionTask(),
                      continueAfter(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        onPressed: () => _submitDone(),
        icon: const Icon(Icons.add),
        label: const Text('Submit'),
      ),
    );
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
                  style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
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

  Widget completionTask() {
    return Container(
      width: fullWidth,
      padding: EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: firstColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Text(
                "Topic-1",
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                elevation: 5,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.only(left: 4, right: 4),
                  title: Text(
                    'Completed ? ',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    'or Studying ?',
                    style: TextStyle(fontSize: 14),
                  ),
                  secondary: IconButton(
                    icon: Icon(
                      Icons.comment,
                      color: firstColor,
                    ),
                    onPressed: () {
                      remarkBox();
                    },
                  ),
                  value: _isStudyCompleted,
                  activeColor: firstColor,
                  onChanged: (complete) {
                    setState(() {
                      _isStudyCompleted = complete;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Studied : ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Th",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: firstColor,
                                  inactiveTrackColor: firstColor,
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 12.0),
                                  thumbColor: firstColor,
                                  overlayColor: firstColor.withAlpha(80),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: firstColor,
                                  inactiveTickMarkColor: firstColor,
                                  valueIndicatorShape:
                                      PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor: firstColor,
                                  valueIndicatorTextStyle: TextStyle(
                                    color: whiteColor,
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
                                  fontSize: 13, fontWeight: FontWeight.w800),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Effectiveness Of Study : ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "0%",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: firstColor,
                                  inactiveTrackColor: firstColor,
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 12.0),
                                  thumbColor: firstColor,
                                  overlayColor: firstColor.withAlpha(80),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: firstColor,
                                  inactiveTickMarkColor: firstColor,
                                  valueIndicatorShape:
                                      PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor: firstColor,
                                  valueIndicatorTextStyle: TextStyle(
                                    color: whiteColor,
                                  ),
                                ),
                                child: Slider(
                                  value: effectivenessOfStudy,
                                  min: 0,
                                  max: 100,
                                  divisions: 20,
                                  label:
                                      effectivenessOfStudy.round().toString(),
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
                                  fontSize: 13, fontWeight: FontWeight.w800),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget continueAfter() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: firstColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Text(
                "Continue Study After:",
                style: TextStyle(color: whiteColor, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "I will start my study at ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
//                      Text("$printHr Hours $printMin mins", style: TextStyle(
//                          fontSize: 14,
//                          fontWeight: FontWeight.w600,
//                          color: Colors.purple),),
                      Text(
                        startStudyAfter,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: MediaQuery.of(context).copyWith().size.height / 6,
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
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
    String completionStatus = "";
    if (_isStudyCompleted) {
      completionStatus = "Complete";
    } else {
      completionStatus = "Studying";
    }
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
          "&topicCompletionStatus=" +
          completionStatus +
          "&theoryPercent=" +
          thOrNum +
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
        if (completionStatus == "Complete") {
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
                contentPadding: EdgeInsets.all(5),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Add Remark",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Find Topics at someLocation",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        elevation: 5,
                        child: Padding(
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
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      buttonText: 'Add Remark',
                      onPressed: () {
                        _addRemark();
                      },
                      verpad: EdgeInsets.symmetric(vertical: 10),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
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
