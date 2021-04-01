import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';

class TopicTest extends StatefulWidget {
  @override
  _TopicTestState createState() => _TopicTestState();
}

class _TopicTestState extends State<TopicTest> {
  var pageData;
  int _index = 0;
  bool reviewLater = false;
  int selectedOptionIndex;
  Timer _timer;
  int _TEST_TIMER_INSECONDS = 600;
  String _FORMATTED_TEST_DURATION = "";
  int _noOFQuestions;
  bool _isFirstQuestion = true;
  bool _isLastQuestion = false;
  PageController _controller =
      PageController(viewportFraction: 1, keepPage: true);
  PageController _controllerList =
      PageController(viewportFraction: 0.15, keepPage: true);
  Map<String, dynamic> _result = Map();
  List _testData = List();
  Map _answerMap = Map();
  Map _bookmarkMap = Map();

  Future _getTestData() async {
    var url = baseUrl + "testQuestions/byTopic?topicSno=1&noOfQuetions=50";
    print(url);
    http.Response response = await http.post(
      Uri.encodeFull(url),
    );
    var responseData = jsonDecode(response.body);
    _result = responseData;
    if (_result['result'].toString() == "true") {
      _testData = jsonDecode(_result['testQuestions'].toString());
    }
    setState(() {
      _noOFQuestions = _testData.length;
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_TEST_TIMER_INSECONDS < 1) {
            timer.cancel();
          } else {
            _TEST_TIMER_INSECONDS = _TEST_TIMER_INSECONDS - 1;
            _FORMATTED_TEST_DURATION =
                _formatDuration(Duration(seconds: _TEST_TIMER_INSECONDS));
          }
        },
      ),
    );
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

  @override
  void initState() {
    startTimer();
    pageData = _getTestData();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topic Test"),
        actions: [
//          RaisedButton(
//            splashColor: Colors.black54,
//            color: Colors.deepPurpleAccent,
//            child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
//            onPressed: (){
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestSummary(_testData,_answerMap,_bookmarkMap,_FORMATTED_TEST_DURATION),));
//            },
//
//          )
        ],
      ),
      body: FutureBuilder(
        future: pageData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [headingRow(), questionRow(), buttonRow()],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget headingRow() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1))
      ]),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 7 / 10,
            child: PageView.builder(
              controller: _controllerList,
              allowImplicitScrolling: true,
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              itemCount: _noOFQuestions,
              dragStartBehavior: DragStartBehavior.start,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateToPage(i,
                          curve: Curves.decelerate,
                          duration: Duration(milliseconds: 300));
                    },
                    child: Container(
                      width: 10,
                      decoration: BoxDecoration(
                        color: _answerMap[_testData[i]['sno']] == null
                            ? _bookmarkMap.containsKey(_testData[i]['sno'])
                                ? Colors.blue
                                : Colors.white
                            : _bookmarkMap.containsKey(_testData[i]['sno'])
                                ? Colors.blue
                                : Colors.green,
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(child: Text((i + 1).toString())),
                    ),
                  ),
                );
              },
            ),
          ),
          Spacer(),
          Icon(Icons.timer),
          SizedBox(
            width: 3,
          ),
          Text(
            _FORMATTED_TEST_DURATION,
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget questionRow() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        height: MediaQuery.of(context).size.height * 7.3 / 10,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        child: PageView.builder(
          controller: _controller,
          scrollDirection: Axis.vertical,
          itemCount: _noOFQuestions,
          onPageChanged: (i) {
            HapticFeedback.selectionClick();
            _controllerList.animateToPage(i,
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 300));
            setState(() {
              _index = i;
              if (i == 0) {
                _isFirstQuestion = true;
              } else if (i == _noOFQuestions - 1) {
                _isLastQuestion = true;
              } else {
                _isFirstQuestion = false;
                _isLastQuestion = false;
              }
            });
          },
          itemBuilder: (context, i) {
            List questionList = _testData[i]['question'].split("##");
            return Transform.scale(
              scale: i == _index ? 1 : 0.95,
              transformHitTests: true,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white54),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Center(
                                child: Text(
                              (i + 1).toString(),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 18,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "4",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "1",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Checkbox(
                            checkColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                if (_bookmarkMap[_testData[i]['sno']] ==
                                    "true") {
                                  reviewLater = false;
//                                  _bookmarkMap.update(_testData[i]['sno'], (value) => "false",ifAbsent: () => "false",);
                                  _bookmarkMap.remove(_testData[i]['sno']);
                                } else {
                                  reviewLater = true;
                                  _bookmarkMap.update(
                                    _testData[i]['sno'],
                                    (value) => "true",
                                    ifAbsent: () => "true",
                                  );
                                }
                                //
                              });
                            },
                            value: _bookmarkMap[_testData[i]['sno']] == "true"
                                ? true
                                : false,
                          ),
                          Text(
                            "Review Later",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 2.5 / 10,
                        child: SingleChildScrollView(
                          child: Row(
                            children: [
                              Expanded(
                                  child: questionList.length < 2
                                      ? Text(_testData[i]['question'])
                                      : ListView.builder(
                                          itemCount: questionList.length,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, q) {
                                            List data = jsonDecode(_result[
                                                _testData[i]['sno']
                                                    .toString()]);
                                            return Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    questionList[q],
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        letterSpacing: 0.7),
                                                  ),
                                                  FadeInImage(
                                                    placeholder: AssetImage(""),
                                                    image: NetworkImage(
                                                        imageUrl +
                                                            data[q]
                                                                ['directory'] +
                                                            "/" +
                                                            data[q]
                                                                ['imageName']),
                                                    height: 100,
                                                    width: 100,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, j) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _answerMap.update(
                                      _testData[i]['sno'],
                                      (value) => j,
                                      ifAbsent: () => j,
                                    );
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            CircleAvatar(
                                              child: Text(
                                                (j + 1).toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              radius: 15,
                                              backgroundColor: _answerMap[
                                                          _testData[i]
                                                              ['sno']] !=
                                                      j
                                                  ? Colors.grey
                                                  : Colors.black87,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: Text(_testData[i][
                                                    'option' +
                                                        (j + 1).toString()]))
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                        color: Colors.black54,
                                        thickness: 3,
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buttonRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6 / 10,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _controller.animateToPage(_index - 1,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 300));
                _controllerList.animateToPage(_index - 1,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 300));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _isFirstQuestion
                        ? Colors.deepPurpleAccent.withOpacity(0.6)
                        : Colors.deepPurpleAccent),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      Text(
                        "Previous",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _controller.animateToPage(_index + 1,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 300));
                _controllerList.animateToPage(_index + 1,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 300));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _isLastQuestion
                        ? Colors.deepPurpleAccent.withOpacity(0.6)
                        : Colors.deepPurpleAccent),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8)),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
