// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../helper/db_helper.dart';
import '../../../helper/dime_repo.dart';
import '../../../helper/reward_repo.dart';
import '../../../helper/study_repo.dart';
import '../../../helper/due_topic_test_repo.dart';
import '../../../helper/pace_repo.dart';
import '../../../helper/recent_study_repo.dart';
import '../../../helper/remark_repo.dart';
import '../../../model/dimes.dart';
import '../../../model/due_topic_test.dart';
import '../../../model/recent_study.dart';
import '../../../model/remark.dart';
import '../../../model/study.dart';
import '../../constant/constant.dart';
import '../../home_page.dart';
import '../test/instruction_page.dart';
import '../../../widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyComplete extends StatefulWidget {
  final time;
  final second;
  final startDate;
  final endDate;
  final course, subject, unit, chapter, topic, duration;
  const StudyComplete(this.time, this.second, this.startDate, this.endDate, this.course, this.subject, this.unit, this.chapter, this.topic, this.duration, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _StudyCompleteState createState() => _StudyCompleteState(time, second, startDate, endDate, course, subject, unit, chapter, topic, duration);
}

class _StudyCompleteState extends State<StudyComplete> {
  String time, second, startDate, endDate, course, subject, unit, chapter, topic, duration;

  _StudyCompleteState(this.time, this.second, this.startDate, this.endDate, this.course, this.subject, this.unit, this.chapter, this.topic, this.duration);
  bool _isStudyCompleted = false;
  // List<String> switchOptions = ["Studying", "Complete"];
  // String selectedSwitchOption = "Studying";
  TextEditingController remarkSubject = TextEditingController();
  TextEditingController remarkMessage = TextEditingController();
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
  DateTime _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Do you want to exit without SUBMIT?', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

  get fullWidth => Responsive.getPercent(100, ResponsiveSize.WIDTH, context);
  Future _getTotalSecondByDate() async {
    try{
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +
      //     "getTotalSecondByDate?date=" +
      //     startDate.split(" ")[0] +
      //     "&registrationSno=" +
      //     sp.getString("studentSno") +
      //     "&totalSeconds=" +
      //     second;
      // print(url);
      // http.Response response = await http.get(
      //   Uri.encodeFull(url),
      // );
      // var resbody = jsonDecode(response.body);
      // Map<String, dynamic> mapResult = resbody;
      // String sum = mapResult['totalSecondByDate'].toString();
      DBHelper dbHelper = DBHelper();
      List<Map<String, dynamic>> list = await dbHelper.totalSecondByDate(startDate.split(" ")[0]);
      double sum = 0;
      for (var a in list) {
        int tSecond = a['totalSecond'] ?? 0;
        sum = tSecond.toDouble() ?? 0;
      }
      // totalDimeEarns = mapResult['totalDimeEarns'];
      RewardRepo repo = RewardRepo();
      List<Map<String, dynamic>> list2 = await repo.getReward();
      String reward = '0';
      for (var a in list2) {
        reward = a['studyTime'] ?? '0';
      }
      double totalDimeEarn = int.parse(reward) * (int.parse(second ?? "0") / 60);
      totalDimeEarns = totalDimeEarn.toStringAsFixed(2) ?? "0";
      if (totalDimeEarns == null) {
        totalDimeEarns = "0";
      }
      await getLeftStudyHour(sum);
    }catch(e){
      print(e);
    }
  }

  Future getLeftStudyHour(double sum) async {
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      PaceRepo paceRepo = PaceRepo();
      List<Map<String, dynamic>> pace = await paceRepo.getPace();
      String totalStudyHr = "0";
      for (var a in pace) {
        totalStudyHr = a['perDayStudyHour'] ?? "0";
      }
      double tStudyHr = double.parse(totalStudyHr) ?? 0;

      totalStudyHour = sp.getDouble("totalStudyHour");
      double totalStudyHourInSeconds = tStudyHr*3600;
      double totalLefSecond = totalStudyHourInSeconds - int.parse(second ?? "0") - sum;
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(Duration(seconds: totalLefSecond.toInt()).inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(Duration(seconds: totalLefSecond.toInt()).inSeconds.remainder(60));
      leftStudyHour = "${twoDigits(Duration(seconds: totalLefSecond.toInt()).inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }catch(e){
      print(e);
    }
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
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: FutureBuilder(
          future: data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Material(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
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
      bottomNavigationBar: CustomButton(
        buttonText: 'SUBMIT',
        onPressed: () => _submitDone(),
        verpad: EdgeInsets.symmetric(vertical: 5),
        brdRds: 0,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   foregroundColor: Colors.white,
      //   onPressed: () => _submitDone(),
      //   icon: const Icon(Icons.add),
      //   label: const Text('Submit'),
      // ),
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
                  style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500, fontSize: 24),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Text(
                "Topic-1",
                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 24),
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
                    _isStudyCompleted ? 'Completed ?' : 'Studying ?',
                    style: TextStyle(fontSize: 18),
                  ),
                  // subtitle: Text(
                  //   'or Studying ?',
                  //   style: TextStyle(fontSize: 14),
                  // ),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Studied : ",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Th",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.62,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: firstColor,
                                  inactiveTrackColor: firstColor,
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                  thumbColor: firstColor,
                                  overlayColor: firstColor.withAlpha(80),
                                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: firstColor,
                                  inactiveTickMarkColor: firstColor,
                                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
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
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Effectiveness Of Study : ",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "0%",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.62,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: firstColor,
                                  inactiveTrackColor: firstColor,
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                  thumbColor: firstColor,
                                  overlayColor: firstColor.withAlpha(80),
                                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: firstColor,
                                  inactiveTickMarkColor: firstColor,
                                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
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
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    setState(
                      () {
                        // ignore: unused_local_variable
                        var formatter = DateFormat("hh:mm a");
                        startStudyAfter = _printDuration(changedtimer);
                      },
                    );
                  },
                ),
              ),
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
    // String hour = printHr.toString();
    // String min = printMin.toString();
    String totalTime = time;
    String totalSecond = second;
    String studentSno = sp.getString("studentSno");
    // String newEndDate = startDate.split(" ")[0] + "23:59:59";
    // String newStartDate = "00:00:00" + endDate.split(" ")[0];
    String completionStatus = "";
    if (_isStudyCompleted) {
      completionStatus = "Complete";
    } else {
      completionStatus = "Studying";
    }
    try {
      DueTopicTestRepo dueTopicTestRepo = DueTopicTestRepo();
      Study study = Study();
      RecentStudy recentStudy = RecentStudy();

      recentStudy.course = course;
      recentStudy.subject = subject;
      recentStudy.unit = unit;
      recentStudy.chapter = chapter;
      recentStudy.topic = topic;
      recentStudy.registrationSno = studentSno;
      recentStudy.duration = duration;
      recentStudy.enteredBy = studentSno;
      recentStudy.enteredDate = DateTime.now().toString();
      recentStudy.studyType = completionStatus;
      recentStudy.status = 'new';

      List<Map<String, dynamic>> list = await dueTopicTestRepo.getDueTopicTestByStatusAndTopicAndRegister('COMPLETE', topic, studentSno);

      study.revision = list.length.toString();

      study.register = studentSno;
      study.startDate = startDate;
      study.endDate = endDate;
      study.totalTime = totalTime;
      study.totalSecond = totalSecond;
      study.topicCompletionStatus = completionStatus;
      study.theoryPercent = thOrNum;
      study.numericalPercent = (100 - theoryOrNum).toString();
      study.effectivenessOfStudy = effectiveStudy;
      study.courseSno = course;
      study.subjectSno = subject;
      study.unitSno = unit;
      study.chapterSno = chapter;
      study.topicSno = topic;
      study.date = startDate.split(" ")[0];
      study.duration = duration;
      study.timePunchedFrom = 'TIMER';
      study.status = 'new';
      study.enteredDate = DateTime.now().toString();

      DateTime sDate = DateFormat('yyyy-MM-dd').parse(startDate);
      DateTime eDate = DateFormat('yyyy-MM-dd').parse(endDate);
      if (eDate.isAfter(sDate)) {
        String oldEndDate = endDate;
        String newEndDate = startDate.split(" ")[0] + " 23:59:59";
        String newStartDate = endDate.split(" ")[0] + " 00:00:00";

        study.endDate = newEndDate;
        StudyRepo repo = StudyRepo();
        repo.insertIntoStudy(study);
        print("First Date Inserted");
        study.startDate = newStartDate;
        study.endDate = oldEndDate;
        repo.insertIntoStudy(study);
        print("Second Date Inserted");
      } else {
        StudyRepo repo = StudyRepo();
        repo.insertIntoStudy(study);
        print("Study Inserted");
      }

      RecentStudyRepo recentStudyRepo = RecentStudyRepo();
      recentStudyRepo.insertIntoRecentStudy(recentStudy);
      print("Recent Inserted");

      Dimes dimes = Dimes();
      dimes.credit = double.parse(totalDimeEarns ?? "0").round();
      dimes.enteredDate = DateTime.now().toString();
      dimes.debit = 0;
      dimes.message = "Study reward for studying " + (int.parse(totalSecond ?? "0") / 60).toStringAsFixed(2) + " minutes";
      dimes.registerSno = studentSno;
      dimes.status = 'new';

      DimeRepo dimeRepo = DimeRepo();
      dimeRepo.insertIntoDimes(dimes);

      print("Dimes Inserted");
      if (completionStatus == 'Complete') {
        List<Map<String, dynamic>> list2 = await dueTopicTestRepo.getDueTopicTestByStatusAndTopicAndRegister('Complete', topic, studentSno);
        if (list2.isEmpty) {
          DueTopicTest dueTopicTest = DueTopicTest();
          dueTopicTest.registerSno = studentSno;
          dueTopicTest.topicSno = topic;
          dueTopicTest.enteredDate = DateTime.now().toString();
          dueTopicTest.status = 'INCOMPLETE';
          dueTopicTest.course = course;
          dueTopicTest.subject = subject;
          dueTopicTest.unit = unit;
          dueTopicTest.chapter = chapter;
          dueTopicTestRepo.insertIntoDueTopicTest(dueTopicTest);
          dueTopicTest.onlineStatus = 'new';
          // FirebaseFirestore.instance.collection('dueTopicTest').add(dueTopicTest.toJson());
          print("Due Topic test inserted");
        }
      }

      // FirebaseFirestore.instance.collection('study').add(study.toJson());
      // FirebaseFirestore.instance.collection('recentStudy').add(recentStudy.toJson());
      // FirebaseFirestore.instance.collection('dimes').add(dimes.toJson());

      toastMethod("Study Saved");
      if (completionStatus == "Complete") {
        _takeTestAlertBox(context);
      } else {
        Navigator.pop(context);
      }

      // var url = baseUrl +
      //     "saveStudy?registrationSno=" +
      //     studentSno +
      //     "&startDate=" +
      //     startDate +
      //     "&endDate=" +
      //     endDate +
      //     "&totalTime=" +
      //     totalTime +
      //     "&totalSecond=" +
      //     totalSecond +
      //     "&topicCompletionStatus=" +
      //     completionStatus +
      //     "&theoryPercent=" +
      //     thOrNum +
      //     "&numericalPercent=" +
      //     (100 - theoryOrNum).toString() +
      //     ""
      //         "&effectivenessOfStudy=" +
      //     effectiveStudy +
      //     ""
      //         "&courseSno=" +
      //     course +
      //     ""
      //         "&subjectSno=" +
      //     subject +
      //     ""
      //         "&unitSno=" +
      //     unit +
      //     ""
      //         "&chapterSno=" +
      //     chapter +
      //     ""
      //         "&topicSno=" +
      //     topic +
      //     ""
      //         "&date=" +
      //     startDate.split(" ")[0] +
      //     ""
      //         "&duration=" +
      //     duration +
      //     "&timePunchedFrom=TIMER";
      // print(url);
      // http.Response response = await http.post(
      //   Uri.encodeFull(url),
      // );
      // var resbody = jsonDecode(response.body);
      // print(resbody);
      // Map<String, dynamic> mapResult = resbody;
      // if (mapResult['saveResult'] == true) {
      //   toastMethod("Study Saved");
      //   if (completionStatus == "Complete") {
      //     _takeTestAlertBox(context);
      //   } else {
      //     Navigator.pop(context);
      //   }
      // } else {
      //   toastMethod("failed");
      // }
    } catch (e) {
      print(e);
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 18.0);
  }

  void _setContinueStudyAfterTime() {
    var formatter = DateFormat('hh:mm a');
    printTime = formatter.format(DateTime.now().add(Duration(hours: printHr, minutes: printMin)));
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
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Find Topics at someLocation",
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
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
                            decoration: InputDecoration(hintText: "Subject :", isDense: true, border: InputBorder.none),
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
                            decoration: InputDecoration(hintText: "Message : ", isDense: true, border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      brdRds: 10,
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
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  Future _addRemark() async {
    if (remarkSubject.text.length < 1) {
      toastMethod("Please Enter Subject For Refrence");
    } else if (remarkMessage.text.length < 1) {
      toastMethod("Please Enter Message");
    } else {
      SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +
      //     "saveRemark?subject=" +
      //     remarkSubject.text +
      //     "&message=" +
      //     remarkMessage.text +
      //     "&topicSno=" +
      //     topic +
      //     "&registrationSno=" +
      //     sp.getString("studentSno");
      // print(url);
      // http.Response response2 = await http.post(
      //   Uri.encodeFull(url),
      // );
      // var resbody2 = jsonDecode(response2.body);
      // Map<String, dynamic> result = resbody2;
      Remark remark = Remark();
      remark.studentSno = sp.getString("studentSno");
      remark.enteredDate = DateTime.now().toString();
      remark.topicSno = topic;
      remark.enteredBy = sp.getString("studentSno");
      remark.subject = remarkSubject.text;
      remark.message = remarkMessage.text;

      RemarkRepo repo = RemarkRepo();
      repo.insertIntoRemark(remark);

      toastMethod("Remark Added");
      Navigator.of(context).pop();
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    // ignore: unused_local_variable
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  _takeTestAlertBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Congratulations! You have completed the topic.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          // ignore: deprecated_member_use
          OutlineButton(
            child: Text("Take Test?"),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => InstructionPage(course, subject, unit, chapter, topic),
              ));
            },
          ),
          // ignore: deprecated_member_use
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

  // ignore: unused_element
  _acceptChallengeBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Congratulations! You have completed the last week challenge. Do you want to take next week challenge",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          // ignore: deprecated_member_use
          OutlineButton(
            child: Text("Take Challenge?"),
            onPressed: () {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Test(topic,"topicTest",[]),));
            },
          ),
          // ignore: deprecated_member_use
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
