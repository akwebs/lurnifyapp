import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/selfstudy/studycomplete.dart';
import 'package:material_switch/material_switch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SyncYourTime extends StatefulWidget {
  final course, subject, unit, chapter, topic, duration;

  SyncYourTime(this.course, this.subject, this.unit, this.chapter, this.topic,
      this.duration);

  @override
  _SyncYourTime createState() =>
      _SyncYourTime(course, subject, unit, chapter, topic, duration);
}

class _SyncYourTime extends State<SyncYourTime> {
  String course, subject, unit, chapter, topic, duration;

  _SyncYourTime(this.course, this.subject, this.unit, this.chapter, this.topic,
      this.duration);

  double _height;
  double _width;
  double startHr = 0;
  double startMin = 0;
  double endHr = 0;
  double endMin = 0;
  List<String> startDays = ["Yesterday", "Today"];
  String selectedStartDays = "Today";
  List<String> endDays = ["Yesterday", "Today"];
  String selectedEndDays = "Today";

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: Container(),
      ),
      body: Material(
        child: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
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
                        bottom: BorderSide(width: 1, color: Colors.blue[100])),
                  ),
                  child: Text(
                    "Study Simplifying Success",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                firstRow(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          startTimeCard(),
                          endTimeCard(),
                          SizedBox(
                            height: 15,
                          )
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
                          _endSession();
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
                  height: _height / 22,
                ),
                Container(
                    width: _width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.blue[100])),
                    ),
                    child: Row(
                      children: [
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

  Widget firstRow() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Colors.red,
              ),
              child: Text(
                "Duration of Study Session",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "2:30 hours",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              "Studied in this purchased session",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget startTimeCard() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
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
              padding: EdgeInsets.only(top: 3, bottom: 3),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Colors.cyan,
              ),
              child: Text(
                "Self Study Starting Time",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: RichText(
                text: TextSpan(
                    style: new TextStyle(
                        fontSize: 13.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(text: "I started self study session "),
                      TextSpan(
                          text: "at " +
                              startHr.round().toString() +
                              ":" +
                              startMin.round().toString() +
                              " $selectedStartDays",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w800,
                              fontSize: 13))
                    ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MaterialSwitch(
                      selectedOption: selectedStartDays,
                      options: startDays,
                      selectedBackgroundColor: Colors.deepPurpleAccent,
                      selectedTextColor: Colors.white,
                      onSelect: (String selectedOption) {
                        setState(() {
                          selectedStartDays = selectedOption;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[100]),
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Hr",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.green[100],
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withAlpha(32),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.green,
                                inactiveTickMarkColor: Colors.green[100],
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.green,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                value: startHr,
                                min: 0,
                                max: 23,
                                divisions: 23,
                                label: startHr.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    startHr = value;
                                    if (startHr != 23) {
                                      endHr = startHr + 1;
                                    }
                                  });
                                },
                              ),
                            ),
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
                    border: Border.all(color: Colors.blue[100]),
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Min",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.orange[700],
                                inactiveTrackColor: Colors.orange[100],
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: Colors.white,
                                overlayColor: Colors.orange.withAlpha(32),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.orange[700],
                                inactiveTickMarkColor: Colors.orange[100],
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.orange,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                value: startMin,
                                min: 0,
                                max: 59,
                                divisions: 59,
                                label: startMin.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    startMin = value;
                                  });
                                },
                              ),
                            ),
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
//            Text(
//              "2:30 hours only",
//              style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 15,
//                  fontWeight: FontWeight.w800),
//            ),
//            Text(
//              "to complete today's study time",
//              style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 15,
//                  fontWeight: FontWeight.w800),
//            ),
//            SizedBox(
//              height: 20,
//            ),
          ],
        ),
      ),
    );
  }

  Widget endTimeCard() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
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
              padding: EdgeInsets.only(top: 3, bottom: 3),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Colors.cyan,
              ),
              child: Text(
                "Self Study End Time",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: RichText(
                text: TextSpan(
                    style: new TextStyle(
                        fontSize: 13.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(text: "I started self study session "),
                      TextSpan(
                          text: "at " +
                              endHr.round().toString() +
                              ":" +
                              endMin.round().toString() +
                              " $selectedEndDays",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w800,
                              fontSize: 13))
                    ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MaterialSwitch(
                      selectedOption: selectedEndDays,
                      options: endDays,
                      selectedBackgroundColor: Colors.deepPurpleAccent,
                      selectedTextColor: Colors.white,
                      onSelect: (String selectedOption) {
                        setState(() {
                          selectedEndDays = selectedOption;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[100]),
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Hr",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.green[700],
                                inactiveTrackColor: Colors.green[100],
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: Colors.white,
                                overlayColor: Colors.green.withAlpha(32),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.green[700],
                                inactiveTickMarkColor: Colors.green[100],
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.green,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                value: endHr,
                                min: 0,
                                max: 23,
                                divisions: 23,
                                label: endHr.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    endHr = value;
                                  });
                                },
                              ),
                            ),
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
                    border: Border.all(color: Colors.blue[100]),
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Min",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.orange[700],
                                inactiveTrackColor: Colors.orange[100],
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: Colors.white,
                                overlayColor: Colors.orange.withAlpha(32),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.orange[700],
                                inactiveTickMarkColor: Colors.orange[100],
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.orange,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                value: endMin,
                                min: 0,
                                max: 59,
                                divisions: 59,
                                label: endMin.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    endMin = value;
                                  });
                                },
                              ),
                            ),
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

  void _endSession() async {
    if (selectedStartDays == "Today" && selectedEndDays == "Yesterday") {
      print("error");
      toastMethod("Invalid Time");
    } else {
      String startDate = "";
      String endDate = "";
      int additionDay = 0;
      if (selectedStartDays == "Yesterday") {
        startDate =
            DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0];
      } else {
        startDate = DateTime.now().toString().split(" ")[0];
      }
      if (selectedEndDays == "Yesterday") {
        endDate =
            DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0];
      } else {
        endDate = DateTime.now().toString().split(" ")[0];
      }
      if (selectedStartDays == "Yesterday" && selectedEndDays == "Today") {
        additionDay = 24 * 60 * 60;
      }
      String startHour = "00",
          startMinute = "00",
          endHour = "00",
          endMinute = "00";
      if (startHr.round().toString().length < 2) {
        startHour = "0" + startHr.round().toString();
      } else {
        startHour = startHr.round().toString();
      }
      if (startMin.round().toString().length < 2) {
        startMinute = "0" + startMin.round().toString();
      } else {
        startMinute = startMin.round().toString();
      }
      if (endHr.round().toString().length < 2) {
        endHour = "0" + endHr.round().toString();
      } else {
        endHour = endHr.round().toString();
      }
      if (endMin.round().toString().length < 2) {
        endMinute = "0" + endMin.round().toString();
      } else {
        endMinute = endMin.round().toString();
      }
      String startingTime = startHour + ":" + startMinute + ":00";
      ;
      String endTime = endHour + ":" + endMinute + ":00";
      int startSeconds =
          Duration(hours: startHr.round(), minutes: startMin.round()).inSeconds;
      int endSeconds =
          Duration(hours: endHr.round(), minutes: endMin.round()).inSeconds +
              additionDay;
      int totalSeconds = endSeconds - startSeconds;
      if (totalSeconds < 1) {
        print("minus error");
        toastMethod("Invalid Time");
      } else {
        print("ok");
        int newHr = endHr.round() - startHr.round();
        int newMin = endMin.round() - startMin.round();
        String time = newHr.toString() + ":" + newMin.toString() + ":00";
        startDate = startDate + " " + startingTime;
        endDate = endDate + " " + endTime;
        SharedPreferences sp = await SharedPreferences.getInstance();
        var url = baseUrl +
            "checkEndDateForManualEntry?date=" +
            startDate +
            "&registrationSno=" +
            sp.getString("studentSno");
        print(url);
        http.Response response = await http.get(
          Uri.encodeFull(url),
        );
        var resbody = jsonDecode(response.body);
        print(resbody);
        Map<String, dynamic> mapResult = resbody;
        if (mapResult['result'].toString() == "true") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudyComplete(
                    time,
                    totalSeconds.toString(),
                    startDate,
                    endDate,
                    course,
                    subject,
                    unit,
                    chapter,
                    topic,
                    duration),
              ));
        } else {
          toastMethod("Please Enter correct end date.");
        }
      }
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
}
