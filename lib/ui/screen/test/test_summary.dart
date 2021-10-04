import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/helper/topic_test_result_repo.dart';
import 'package:lurnify/helper/due_topic_test_repo.dart';
import 'package:lurnify/model/topic_test_result.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/test/test_result.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class TestSummary extends StatefulWidget {
  final Map _answerMap, _bookmarkMap;
  final List _testData;
  final String _FORMATTED_TEST_DURATION, testType;
  final sno, course, subject, unit, chapter;
  final int totalSecond;
  final Map<String, dynamic> questionTiming;

  TestSummary(this._testData, this._answerMap, this._bookmarkMap, this._FORMATTED_TEST_DURATION, this.sno, this.testType, this.course, this.subject, this.unit, this.chapter, this.totalSecond,
      this.questionTiming);

  @override
  _TestSummaryState createState() => _TestSummaryState(_testData, _answerMap, _bookmarkMap, _FORMATTED_TEST_DURATION, sno, testType, course, subject, unit, chapter, totalSecond);
}

class _TestSummaryState extends State<TestSummary> {
  final Map _answerMap, _bookmarkMap;
  final List _testData;
  final sno, course, subject, unit, chapter;
  String _FORMATTED_TEST_DURATION, testType;
  final int totalSecond;
  DateTime _currentBackPressTime;
  _TestSummaryState(this._testData, this._answerMap, this._bookmarkMap, this._FORMATTED_TEST_DURATION, this.sno, this.testType, this.course, this.subject, this.unit, this.chapter, this.totalSecond);

  String totalNoOFQuestions = "0";
  String totalNoOFAnsweredQuestions = "0";
  String totalUnanswered = "0";
  String totalReviewLater = "0";
  int _correctQuestion = 0;
  int _wrongAnswer = 0;
  int _resultNumber = 0;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press BACK again to exit Test', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

  // ignore: missing_return
  Future getTestSummary() {
    totalNoOFQuestions = _testData.length.toString();
    totalNoOFAnsweredQuestions = _answerMap.length.toString();
    totalUnanswered = (_testData.length - _answerMap.length).toString();
    totalReviewLater = _bookmarkMap.length.toString();
  }

  @override
  void initState() {
    print(widget.questionTiming);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = context.screenHeight;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summary"),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getTestSummary(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return WillPopScope(
                onWillPop: _onWillPop,
                child: [
                  PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: [
                      "Remaining Time".text.make().p8(),
                      _FORMATTED_TEST_DURATION.text.semiBold.xl5.makeCentered().py4().h16(context),
                    ].vStack(crossAlignment: CrossAxisAlignment.start).p8().wFull(context),
                  ),
                  [
                    // [
                    //   "Remaining Time".text.make().py8(),
                    //   _FORMATTED_TEST_DURATION.text.semiBold.xl3.make().py4(),
                    // ]
                    //     .vStack()
                    //     .p8()
                    //     .box
                    //     .withDecoration(
                    //       const BoxDecoration(
                    //         border: Border(top: BorderSide(color: Vx.purple300, width: 5)),
                    //       ),
                    //     )
                    //     .make()
                    //     .card
                    //     .make()
                    //     .wFull(context),
                    [
                      [
                        "All Questions".text.make().py8(),
                        totalNoOFQuestions.text.semiBold.xl3.make().py4(),
                      ]
                          .vStack()
                          .p8()
                          .box
                          .withDecoration(
                            const BoxDecoration(
                              border: Border(top: BorderSide(color: Vx.yellow500, width: 5)),
                            ),
                          )
                          .make()
                          .card
                          .elevation(10)
                          .make()
                          .expand(),
                      [
                        "Answered".text.make().py8(),
                        totalNoOFAnsweredQuestions.text.semiBold.xl3.make().py4(),
                      ]
                          .vStack()
                          .p8()
                          .box
                          .withDecoration(
                            const BoxDecoration(
                              border: Border(top: BorderSide(color: Vx.green300, width: 5)),
                            ),
                          )
                          .make()
                          .card
                          .elevation(10)
                          .make()
                          .expand(),
                    ].hStack().p8(),
                    20.heightBox,
                    [
                      [
                        "Unanswered".text.make().py8(),
                        totalUnanswered.text.semiBold.xl3.make().py4(),
                      ]
                          .vStack()
                          .p8()
                          .box
                          .withDecoration(
                            const BoxDecoration(
                              border: Border(top: BorderSide(color: Vx.red300, width: 5)),
                            ),
                          )
                          .make()
                          .card
                          .elevation(10)
                          .make()
                          .expand(),
                      [
                        "Review Later".text.make().py8(),
                        totalReviewLater.text.semiBold.xl3.make().py4(),
                      ]
                          .vStack()
                          .p8()
                          .box
                          .withDecoration(
                            const BoxDecoration(
                              border: Border(top: BorderSide(color: Vx.blue300, width: 5)),
                            ),
                          )
                          .make()
                          .card
                          .elevation(10)
                          .make()
                          .expand(),
                    ].hStack().p8()
                  ].vStack()
                ].vStack().scrollVertical());
          }
        },
      ),
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        buttonText: "Submit",
        verpad: const EdgeInsets.symmetric(vertical: 5),
        onPressed: () {
          _testSubmit();
        },
      ),
    );
  }

  Future _testSubmit() async {
    _correctQuestion = 0;
    _resultNumber = 0;
    _wrongAnswer = 0;
    SharedPreferences sp = await SharedPreferences.getInstance();
    for (int i = 0; i < _testData.length; i++) {
      if (_answerMap.containsKey(_testData[i]['sno'])) {
        if (_answerMap[_testData[i]['sno']].toString() == _testData[i]['answer']) {
          _correctQuestion = _correctQuestion + 1;
          _resultNumber = _resultNumber + 4;
        } else {
          _wrongAnswer = _wrongAnswer + 1;
          _resultNumber = _resultNumber - 1;
        }
      }
    }
    int _wrongQuestion = _testData.length - _correctQuestion;
    double _testPercent = (_correctQuestion / _testData.length) * 100;
    var url = "";
    int result = 0;
    if (testType == "topicTest") {
      TopicTestResult topicTestResult = new TopicTestResult();
      topicTestResult.regSno = sp.getString("studentSno");
      topicTestResult.totalQuestion = _testData.length.toString();
      topicTestResult.correctQuestion = _correctQuestion.toString();
      topicTestResult.wrongQuestion = _wrongQuestion.toString();
      topicTestResult.resultNumber = _resultNumber.toString();
      topicTestResult.testPercent = _testPercent.toStringAsFixed(2);
      topicTestResult.answerMap = _answerMap.toString();
      topicTestResult.totalTestTime = totalSecond.toString();

      topicTestResult.enteredDate = DateTime.now().toString();
      topicTestResult.topicSno = sno.toString();
      topicTestResult.course = course.toString();
      topicTestResult.subject = subject.toString();
      topicTestResult.unit = unit.toString();
      topicTestResult.chapter = chapter.toString();
      topicTestResult.status = 'new';

      topicTestResult.questionTiming = jsonEncode(widget.questionTiming);

      TopicTestResultRepo topicTestResultRepo = new TopicTestResultRepo();
      result = await topicTestResultRepo.insertIntoTopicTestResult(topicTestResult);

      // FirebaseFirestore.instance.collection('topicTestResult').add(topicTestResult.toJson());
      if (_testPercent >= 50) {
        DueTopicTestRepo dueTopicTestRepo = new DueTopicTestRepo();
        List<Map<String, dynamic>> list2 = await dueTopicTestRepo.getDueTopicTestByStatusAndTopicAndRegister('INCOMPLETE', sno, sp.getString("studentSno"));
        if (list2.isNotEmpty) {
          dueTopicTestRepo.updateDueTopicTest(sno);
          FirebaseFirestore.instance
              .collection('dueTopicTest')
              .where('status', isEqualTo: 'INCOMPLETE')
              .where('topicSno', isEqualTo: sno)
              .where('registerSno', isEqualTo: sp.getString("studentSno"))
              .get()
              .then((QuerySnapshot snapshot) {
            snapshot.docs.forEach((element) {
              element.reference.update({'status': 'Complete'});
            });
          });
        }
      }
      // url = baseUrl +
      //     "saveTopicTest?regSno=" +
      //     sp.getString("studentSno") +
      //     "&totalQuestion=" +
      //     _testData.length.toString() +
      //     "&correctQuestion=" +
      //     _correctQuestion.toString() +
      //     "&wrongQuestion=" +
      //     _wrongQuestion.toString() +
      //     "&resultNumber=" +
      //     _resultNumber.toString() +
      //     "&testPercent=" +
      //     _testPercent.toStringAsFixed(2) +
      //     "&topicSno=" +
      //     sno.toString();
    } else if (testType == "rankBoosterTest") {
      url = baseUrl +
          "saveRankBoosterTest?regSno=" +
          sp.getString("studentSno") +
          "&totalQuestion=" +
          _testData.length.toString() +
          "&correctQuestion=" +
          _correctQuestion.toString() +
          "&wrongQuestion=" +
          _wrongQuestion.toString() +
          "&resultNumber=" +
          _resultNumber.toString() +
          "&testPercent=" +
          _testPercent.toStringAsFixed(2);
    }

    // print(url);
    // print(_answerMap.toString());
    // http.Response response = await http.post(Uri.encodeFull(url),
    //     body: jsonEncode(_answerMap.toString()));
    // var responseData = jsonDecode(response.body);
    // print(responseData);
    if (result > 0) {
      toastMethod("Test Submitted Successful");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TestResult(_correctQuestion, _wrongAnswer, _resultNumber, _testData, _answerMap, _bookmarkMap, _FORMATTED_TEST_DURATION), //yha pr response ko hataye hai
      ));
    } else {
      toastMethod("Failed.");
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 18.0);
  }
}
