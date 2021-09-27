// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:velocity_x/velocity_x.dart';
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
    try {
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
      totalDimeEarns = totalDimeEarn.toStringAsFixed(0) ?? "0";
      if (totalDimeEarns == null) {
        totalDimeEarns = "0";
      }
      await getLeftStudyHour(sum);
    } catch (e) {
      print(e);
    }
  }

  Future getLeftStudyHour(double sum) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      PaceRepo paceRepo = PaceRepo();
      List<Map<String, dynamic>> pace = await paceRepo.getPace();
      String totalStudyHr = "0";
      for (var a in pace) {
        totalStudyHr = a['perDayStudyHour'] ?? "0";
      }
      double tStudyHr = double.parse(totalStudyHr) ?? 0;

      totalStudyHour = sp.getDouble("totalStudyHour");
      double totalStudyHourInSeconds = tStudyHr * 3600;
      double totalLefSecond = totalStudyHourInSeconds - int.parse(second ?? "0") - sum;
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(Duration(seconds: totalLefSecond.toInt()).inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(Duration(seconds: totalLefSecond.toInt()).inSeconds.remainder(60));
      leftStudyHour = "${twoDigits(Duration(seconds: totalLefSecond.toInt()).inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } catch (e) {
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
        elevation: 0,
        title: const Text("Study Session Reporting"),
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
    return [
      "Congratulations!".text.semiBold.xl2.center.white.make().px12().box.shadowMd.roundedSM.p8.color(Vx.green500).make(),
      [
        [
          "Earned ".text.make(),
          "$totalDimeEarns ".text.green500.semiBold.xl4.make(),
          Image.asset(
            'assets/images/sss/dime.png',
            height: 25,
            width: 25,
            fit: BoxFit.contain,
          ),
        ].hStack().p4(),
        10.heightBox,
        [
          VxTwoColumn(top: '4h:20m'.text.wider.center.semiBold.xl4.make(), bottom: 'Studied Today'.text.center.sm.make()).centered().expand(),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ).h10(context),
          VxTwoColumn(top: '4h:20m'.text.wider.center.semiBold.xl4.make(), bottom: 'Studied Today'.text.center.sm.make()).centered().expand(),
        ].hStack().wFull(context),
        // Text(
        //   leftStudyHour.isEmpty ? "0" : leftStudyHour,
        // ).text.xl4.semiBold.color(Vx.red600).make(),
        "to complete today's study time".text.make().p8(),
      ].vStack().p8(),
    ].vStack().card.elevation(10).p4.make().wFull(context);
  }

  Widget completionTask() {
    return [
      // IconButton(
      //     icon: Icon(
      //       Icons.comment,
      //       color: firstColor,
      //     ),
      //     onPressed: () {
      //       remarkBox();
      //     },
      //   ),
      "Topic Details".text.semiBold.lg.center.make().box.p8.color(Vx.purple200).make().wFull(context),
      10.heightBox,
      SwitchListTile(
        contentPadding: const EdgeInsets.only(left: 12, right: 12),
        title: Text(
          _isStudyCompleted ? 'Completed' : 'Studying',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          _isStudyCompleted ? 'Studying ?' : 'Completed ?',
        ),
        value: _isStudyCompleted,
        activeColor: firstColor,
        onChanged: (complete) {
          setState(() {
            _isStudyCompleted = complete;
          });
        },
      ),
      10.heightBox,
      [
        [
          "Effectiveness Of Study : ".text.make(),
          const Spacer(),
          const Icon(
            Icons.info_outline_rounded,
            size: Vx.dp20,
          ).onTap(() {
            _info('How effective you studied according to understanding the concept and topic.');
          }),
        ].hStack(),
        [
          "0%".text.make(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.62,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: firstColor,
                inactiveTrackColor: firstColor.withOpacity(0.7),
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 3.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                thumbColor: firstColor,
                overlayColor: firstColor.withAlpha(80),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: firstColor,
                inactiveTickMarkColor: firstColor,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: firstColor,
                valueIndicatorTextStyle: TextStyle(
                  color: whiteColor,
                ),
              ),
              child: Slider(
                value: effectivenessOfStudy,
                min: 0,
                max: 100,
                divisions: 10,
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
          "100%".text.make(),
        ].hStack(alignment: MainAxisAlignment.spaceBetween).wFull(context),
      ].vStack().px16(),
      10.heightBox,
      [
        [
          "Studied : ".text.make(),
          const Spacer(),
          const Icon(
            Icons.info_outline_rounded,
            size: Vx.dp20,
          ).onTap(() {
            _info('How effective you studied according to understanding the concept and topic.');
          }),
        ].hStack(),
        [
          "Th".text.make(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.62,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: firstColor,
                inactiveTrackColor: firstColor.withOpacity(0.7),
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 3.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                thumbColor: firstColor,
                overlayColor: firstColor.withAlpha(80),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: firstColor,
                inactiveTickMarkColor: firstColor,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: firstColor,
                valueIndicatorTextStyle: TextStyle(
                  color: whiteColor,
                ),
              ),
              child: Slider(
                value: theoryOrNum,
                min: 0,
                max: 100,
                divisions: 10,
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
          "Num".text.make(),
        ].hStack(alignment: MainAxisAlignment.spaceBetween).wFull(context),
      ].vStack().px16(),
      VxBox().color(Vx.purple200).make().h2(context).wFull(context)
    ].vStack().card.elevation(10).p8.make().py4();
  }

  _info(String message) async {
    showCupertinoModalBottomSheet(
        barrierColor: Vx.black.withOpacity(0.7),
        context: context,
        builder: (builder) {
          return message.text.lg.make().p12().card.elevation(0).make().p8();
        });
  }

  Widget continueAfter() {
    TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);

    void _selectTime() async {
      final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: _time,
      );
      if (newTime != null) {
        setState(() {
          _time = newTime;
          startStudyAfter = newTime.toString();
        });
      }
    }

    return [
      "Continue Study After".text.semiBold.lg.center.make().box.p8.color(Vx.purple200).make().wFull(context),
      [
        "Select Time".text.xl.semiBold.make().p8().card.make().onInkTap(
              _selectTime,
            ),
        Text(
          'I will start my study at : ${_time.format(context)}',
        ).text.make(),
      ].vStack().p8(),
      // Padding(
      //   padding: EdgeInsets.all(10),
      //   child: Container(
      //     padding: EdgeInsets.only(left: 10),
      //     height: MediaQuery.of(context).copyWith().size.height / 6,
      //     child: CupertinoTimerPicker(
      //       mode: CupertinoTimerPickerMode.hm,
      //       alignment: Alignment.center,
      //       onTimerDurationChanged: (Duration changedtimer) {
      //         setState(
      //           () {
      //             // ignore: unused_local_variable
      //             var formatter = DateFormat("hh:mm a");
      //             startStudyAfter = _printDuration(changedtimer);
      //           },
      //         );
      //       },
      //     ),
      //   ),
      // ),
      // SizedBox(
      //   height: 20,
      // ),
      VxBox().color(Vx.purple200).make().h2(context).wFull(context)
    ].vStack().card.elevation(10).p8.make().py12().wFull(context);
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
                      brdRds: 5,
                      buttonText: 'Add Remark',
                      onPressed: () {
                        _addRemark();
                      },
                      verpad: EdgeInsets.symmetric(vertical: 0),
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
