import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/Animation/FadeAnimation.dart';
import 'package:lurnify/helper/helper.dart';
import 'package:lurnify/model/model.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectThePace extends StatefulWidget {
  final bool backButtonWillWork;
  SelectThePace(this.backButtonWillWork);
  @override
  _SelectThePaceState createState() => _SelectThePaceState(backButtonWillWork);
}

class _SelectThePaceState extends State<SelectThePace> {
  _SelectThePaceState(this.backButtonWillWork);
  final bool backButtonWillWork;
  String _radioValue; //Initial definition of radio button value
  String choice;
  bool customProgram = false;
  String completionDate = "";
  double totalDuration = 0;
  String customValue;
  String expectedRank;
  double totalTiming = 0.0;
  var formatter = new DateFormat('dd MMM yyyy');
  var _data;

  Future getTotalTopicDuration() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +
      //     "getDurationByCourse?courseSno=" +
      //     sp.get("courseSno") +
      //     "&registrationSno=" +
      //     sp.getString("studentSno");
      // print(url);
      // http.Response response = await http.get(
      //   Uri.encodeFull(url),
      // );
      // var resbody = jsonDecode(response.body);
      // Map<String, dynamic> map = resbody;
      DBHelper dbHelper = new DBHelper();
      List<Map<String, dynamic>> map =
          await dbHelper.getTotalTopicDurationByCourse(sp.get("courseSno"));
      int tDuration = 0;
      for (var a in map) {
        tDuration = a['totalDuration'] ?? 0;
      }
      String getTotalDuration = tDuration.toString() ?? "0";
      totalDuration = double.parse(getTotalDuration);
      // totalDuration = 0;
      // toastMethod(totalDuration.toString());
    } catch (e) {
      print(e);
      toastMethod(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    completionDate = formatter.format(DateTime.now().add(Duration(days: 180)));
    _data = getTotalTopicDuration();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => backButtonWillWork,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Self Study Program Pace"),
          centerTitle: true,
          elevation: 0,
          leading: backButtonWillWork
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                )
              : Container(),
        ),
        body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Material(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      mainContent(),
                    ],
                  ),
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
        bottomNavigationBar: SizedBox(
          width: Responsive.getPercent(90, ResponsiveSize.WIDTH, context),
          child: CustomButton(
            brdRds: 0,
            buttonText: 'DONE',
            onPressed: () {
              submit();
            },
            verpad: EdgeInsets.symmetric(vertical: 5),
          ),
        ),
      ),
    );
  }

  Widget mainContent() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            FadeAnimation(1.2, rankSelector()),
            FadeAnimation(1.4, completionDateSet()),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(1.6, studyHoursPick()),
          ],
        ),
      ),
    );
  }

  Widget completionDateSet() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.deepPurple),
        child: Column(
          children: [
            Text(
              "Set Syllabus completion date",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) => 3.0,
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Colors.white),
                    overlayColor: MaterialStateProperty.all(Colors.black26),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      completionDate == null || completionDate == ""
                          ? formatter
                              .format(DateTime.now().add(Duration(days: 180)))
                          : completionDate,
                      style: TextStyle(
                          color: firstColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _selectDate(context);
                  },
                  color: Colors.amberAccent,
                  iconSize: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget studyHoursPick() {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: firstColor),
            padding: EdgeInsets.symmetric(vertical: 10),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Text(
              "Self Study Average Hours Per Day",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
          Row(
            children: [
              Radio(
                value: 'one',
                groupValue: _radioValue,
                onChanged: radioButtonChanges,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Standard Program:",
                  ),
                  Text(
                    "6 Hrs a Day",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'two',
                groupValue: _radioValue,
                onChanged: radioButtonChanges,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Comprehensive Program:",
                  ),
                  Text(
                    "8 Hrs a Day",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'three',
                groupValue: _radioValue,
                onChanged: radioButtonChanges,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exhaustive Program:",
                  ),
                  Text(
                    "10 Hrs a Day",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'four',
                groupValue: _radioValue,
                onChanged: radioButtonChanges,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Custom Program:",
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(hintText: "4.5"),
                          enabled: customProgram,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              totalTiming = double.parse(value);
                            });
                          },
                        ),
                      ),
                      Text(
                        "Hrs",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget rankSelector() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.deepPurple),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Rank Expectation : ",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[100]),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: expectedRank,
                  isDense: true,
                  dropdownColor: Colors.deepPurpleAccent,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  iconEnabledColor: Colors.white,
                  items: <String>['1-100', '101-1000', '1001-2000', '2001-5000']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      expectedRank = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          customProgram = false;
          customValue = null;
          choice = value;
          totalTiming = 6;
          break;
        case 'two':
          customProgram = false;
          customValue = null;
          choice = value;
          totalTiming = 8;
          break;
        case 'three':
          customProgram = false;
          customValue = null;
          choice = value;
          totalTiming = 10;
          break;
        case 'four':
          customProgram = true;
          customValue = null;
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      confirmText: 'Confirm',
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2023),
    );

    if (picked != null)
      setState(() {
        selectedDate = picked;

        completionDate = formatter.format(selectedDate);
        print(picked);
      });
  }

  void submit() async {
    double totalPerDayHours = 0;
    try {
      if (selectedDate.toString().split(" ")[0] ==
          DateTime.now().toString().split(" ")[0]) {
        toastMethod("Please Select Syllabus Completion Date");
      } else {
        Duration inDays = selectedDate.difference(DateTime.now());
        int convertedInDays = inDays.inDays;
        print(totalDuration);
        if (customValue == null) {
          totalPerDayHours = (totalDuration / 60).round() / convertedInDays;
        } else {
          totalPerDayHours = double.parse(customValue);
        }
        print(totalPerDayHours);
        if (totalPerDayHours > 15) {
          toastMethod("Too Less");
        } else {
          SharedPreferences sp = await SharedPreferences.getInstance();
          String studentSno = sp.getString("studentSno");
          String syllabusCompletionDate = selectedDate.toString();
          String perDayStudyHour = totalTiming.toString();
          String courseSno = sp.get("courseSno");
          // var url = baseUrl +
          //     "savePace?registrationSno=" +
          //     studentSno +
          //     "&syllabusCompletionDate=" +
          //     syllabusCompletionDate +
          //     "&perDayStudyHour=" +
          //     perDayStudyHour +
          //     "&expectedRank=" +
          //     expectedRank +
          //     "&courseSno=" +
          //     courseSno;
          // http.Response response = await http.post(
          //   Uri.encodeFull(url),
          // );
          // var resbody = jsonDecode(response.body);
          // print(resbody);
          // Map<String, dynamic> mapResult = resbody;
          Pace pace = new Pace();
          pace.courseSno = courseSno;
          pace.enteredDate = DateTime.now().toString();
          pace.studentSno = studentSno;
          pace.expectedRank = expectedRank;
          pace.perDayStudyHour = perDayStudyHour;
          pace.syllabusCompletionDate = syllabusCompletionDate;

          PaceRepo paceRepo = new PaceRepo();
          paceRepo.insertIntoPace(pace);
          toastMethod("Data Saved Successfully");

          sp.setString("courseCompletionDate", completionDate);
          sp.setString("courseCompletionDateFormatted",
              selectedDate.toString().split(" ")[0]);
          sp.setString(
              "courseStartingDate", DateTime.now().toString().split(" ")[0]);
          sp.setInt("totalWeeks",
              (selectedDate.difference(DateTime.now()).inDays / 7).round());
          sp.setDouble("totalStudyHour", totalTiming);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              ModalRoute.withName('/'));
        }
      }
    } catch (e) {
      toastMethod("123 " + e.toString());
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
