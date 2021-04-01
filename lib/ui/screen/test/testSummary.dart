import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/test/testResult.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TestSummary extends StatefulWidget {
  final Map _answerMap, _bookmarkMap;
  final List _testData;
  final String _FORMATTED_TEST_DURATION, testType;
  final sno;

  TestSummary(this._testData, this._answerMap, this._bookmarkMap,
      this._FORMATTED_TEST_DURATION, this.sno, this.testType);

  @override
  _TestSummaryState createState() => _TestSummaryState(_testData, _answerMap,
      _bookmarkMap, _FORMATTED_TEST_DURATION, sno, testType);
}

class _TestSummaryState extends State<TestSummary> {
  final Map _answerMap, _bookmarkMap;
  final List _testData;
  final sno;
  String _FORMATTED_TEST_DURATION, testType;

  _TestSummaryState(this._testData, this._answerMap, this._bookmarkMap,
      this._FORMATTED_TEST_DURATION, this.sno, this.testType);

  String totalNoOFQuestions = "0";
  String totalNoOFAnsweredQuestions = "0";
  String totalUnanswered = "0";
  String totalReviewLater = "0";
  int _correctQuestion = 0;
  int _wrongAnswer = 0;
  int _resultNumber = 0;

  Future getTestSummary() {
    totalNoOFQuestions = _testData.length.toString();
    totalNoOFAnsweredQuestions = _answerMap.length.toString();
    totalUnanswered = (_testData.length - _answerMap.length).toString();
    totalReviewLater = _bookmarkMap.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Summary"),
        ),
        body: FutureBuilder(
          future: getTestSummary(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.amberAccent),
                        child: Center(
                          child: Text(
                            "Remaining Time ($_FORMATTED_TEST_DURATION)",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.black38),
                        child: Center(
                          child: Text(
                            "All Questions ($totalNoOFQuestions)",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.green),
                        child: Center(
                          child: Text(
                            "Answered ($totalNoOFAnsweredQuestions)",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: Text(
                            "Unanswered ($totalUnanswered)",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Center(
                          child: Text(
                            "Review Later ($totalReviewLater)",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.deepPurpleAccent,
                        splashColor: Colors.black87,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          _testSubmit();
                        },
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  Future _testSubmit() async {
    _correctQuestion = 0;
    _resultNumber = 0;
    _wrongAnswer = 0;
    SharedPreferences sp = await SharedPreferences.getInstance();
    for (int i = 0; i < _testData.length; i++) {
      if (_answerMap.containsKey(_testData[i]['sno'])) {
        if (_answerMap[_testData[i]['sno']].toString() ==
            _testData[i]['answer']) {
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
    if (testType == "topicTest") {
      url = baseUrl +
          "saveTopicTest?regSno=" +
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
          _testPercent.toStringAsFixed(2) +
          "&topicSno=" +
          sno.toString();
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

    print(url);
    print(_answerMap.toString());
    http.Response response = await http.post(Uri.encodeFull(url),
        body: jsonEncode(_answerMap.toString()));
    var responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData['result'] == true) {
      toastMethod("Test Submitted Successful");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TestResult(_correctQuestion, _wrongAnswer,
            _resultNumber, _testData, _answerMap, _bookmarkMap, responseData),
      ));
    } else {
      toastMethod("Failed.");
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
