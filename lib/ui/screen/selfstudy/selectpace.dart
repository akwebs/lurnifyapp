import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/Animation/FadeAnimation.dart';
import 'package:lurnify/helper/helper.dart';
import 'package:lurnify/model/pace.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
  String expectedRank = "101-1000";
  double totalTiming = 0.0;
  var formatter = new DateFormat('dd MMM yyyy');
  var _data;
  DateTime selectedDate = DateTime.now();
  double totalPerDayHours = 0;

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

      Database database = await dbHelper.database;
      String sql = "select * from pace order by sno desc limit 1";
      List<Map<String, dynamic>> list = await database.rawQuery(sql);
      for (var a in list) {
        print(a);
        expectedRank = a['expectedRank'];
        completionDate = DateFormat('dd MMM yyyy')
            .parse(a['syllabusCompletionDate'])
            .toString();
        totalPerDayHours = a['perDayStudyHour'];
      }
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
    // completionDate = formatter.format(DateTime.now().add(Duration(days: 180)));
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
            ),
            Text(
              "Your standard hours will be ${totalPerDayHours.toStringAsFixed(2)}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              "But you can still choose as per your want",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
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
      }

      debugPrint(choice); //Debug the choice in console
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      confirmText: 'Confirm',
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2023),
    );

    if (picked != null) selectedDate = picked;
    if (DateFormat('EEEE').format(selectedDate) == "Sunday") {
      completionDate = formatter.format(selectedDate);
      print(completionDate);
      SharedPreferences sp = await SharedPreferences.getInstance();
      print(sp.getString('firstMonday'));
      Duration inDays =
          selectedDate.difference(DateTime.parse(sp.getString('firstMonday')));
      int convertedInDays = inDays.inDays;
      print(convertedInDays);
      print(totalDuration);
      setState(() {
        if (customValue == null) {
          totalPerDayHours = (totalDuration / 60).round() / convertedInDays;
        } else {
          totalPerDayHours = double.parse(customValue);
        }
        print(totalPerDayHours);
      });
    } else {
      Fluttertoast.showToast(msg: 'Selected Date should be sunday');
    }
  }

  void submit() async {
    try {
      if (selectedDate.toString().split(" ")[0] ==
          DateTime.now().toString().split(" ")[0]) {
        toastMethod("Please Select Syllabus Completion Date");
      } else {
        // Duration inDays = selectedDate.difference(DateTime.now());
        // int convertedInDays = inDays.inDays;
        // print(totalDuration);
        // if (customValue == null) {
        //   totalPerDayHours = (totalDuration / 60).round() / convertedInDays;
        // } else {
        //   totalPerDayHours = double.parse(customValue);
        // }
        print(totalPerDayHours);
        if (totalPerDayHours > 15) {
          toastMethod("Too Less");
        } else {
          SharedPreferences sp = await SharedPreferences.getInstance();
          String studentSno = sp.getString("studentSno");
          String syllabusCompletionDate = selectedDate.toString();

          if (totalTiming == null) {
            totalTiming = totalPerDayHours;
          }

          String perDayStudyHour = totalTiming.toString();
          double userStudyHourDifference =
              totalTiming - totalPerDayHours; //user selected-standard time
          double percentDifference =
              (userStudyHourDifference * 100) / totalPerDayHours;
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
          pace.percentDifference = percentDifference.toStringAsFixed(2);
          pace.register = sp.getString('studentSno');

          PaceRepo paceRepo = new PaceRepo();
          paceRepo.insertIntoPace(pace);

          FirebaseFirestore.instance.collection('pace').add(pace.toJson());

          toastMethod("Data Saved Successfully");

          sp.setString("courseCompletionDate", completionDate);
          sp.setString("courseCompletionDateFormatted",
              selectedDate.toString().split(" ")[0]);
          //
          sp.setString("courseStartingDate", sp.getString('firstMonday'));
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
