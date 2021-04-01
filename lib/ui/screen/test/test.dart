import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/screen/test/testSummary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  final Map<String, dynamic> testData;
  final String testType;
  final sno;
  Test(this.testData, this.testType, this.sno);
  @override
  _TestState createState() => _TestState(testData, testType, sno);
}

class _TestState extends State<Test> with TickerProviderStateMixin {
  final Map<String, dynamic> testData;
  final String testType, sno;
  _TestState(this.testData, this.testType, this.sno);
  int _index = 0;
  bool reviewLater = false;
  int selectedOptionIndex;
  Timer _timer;
  int _TEST_TIMER_INSECONDS = 1200;
  int _questionTime = 0;
  String _FORMATTED_TEST_DURATION = "";
  int _noOFQuestions;
  bool _isFirstQuestion = true;
  bool _isLastQuestion = false;
  PageController _controller =
      PageController(viewportFraction: 1, keepPage: true);
  PageController _controllerList =
      PageController(viewportFraction: 0.15, keepPage: true);
  AnimationController _controllerFloat;
  Map _answerMap = Map();
  Map _bookmarkMap = Map();
  String _toolBarName = "";
  String _testName = "";
  List _testQuestions = [];
  Map<String, int> _questionTiming = Map();
  static const List<IconData> icons = const [
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];
  static const List<String> iconsText = const [
    "Submit",
    "Current Section Instruction",
    "Test Instruction"
  ];

  // Future _getTestData() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   var url = baseUrl + "getTestByTopic?topicSno="+sno+"&registerSno="+sp.getString("studentSno");
  //   print(url);
  //   http.Response response = await http.get(
  //     Uri.encodeFull(url),
  //   );
  //   var responseData = jsonDecode(response.body);
  //   _testData=responseData;
  //   print(_testData);
  //   _testQuestions=_testData['test'];
  //   setState(() {
  //     _noOFQuestions = _testQuestions.length;
  //     _toolBarName = _testData['testName'];
  //     _testName = _testData['testName'];
  //   });
  //
  // }

  // Future _getRankBoosterTestData()async{
  //   _testQuestions=list[0]['test'];
  //   setState(() {
  //     _noOFQuestions = _testQuestions.length;
  //     _toolBarName = "Rank Booster Test";
  //     _testName = "Rank Booster Test";
  //   });
  // }

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
            _questionTime = _questionTime + 1;
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
    _testQuestions = testData['test'];
    print(_testQuestions);
    _noOFQuestions = _testQuestions.length;
    _toolBarName = testData['testName'];
    _testName = testData['testName'];
    startTimer();
    _controllerFloat = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
        title: Text(_toolBarName),
      ),
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
//            width: 110.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
                scale: new CurvedAnimation(
                  parent: _controllerFloat,
                  curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                      curve: Curves.fastOutSlowIn),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        iconsText[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.deepPurpleAccent,
                      mini: true,
                      child: new Icon(icons[index], color: Colors.white),
                      onPressed: () {
                        _floatingButtonClick(index);
                      },
                    ),
                  ],
                )),
          );
          return child;
        }).toList()
          ..add(
            Container(
              margin: EdgeInsets.only(bottom: 35),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.deepPurpleAccent,
                child: new AnimatedBuilder(
                  animation: _controllerFloat,
                  builder: (BuildContext context, Widget child) {
                    return new Transform(
                      transform: new Matrix4.rotationZ(
                          _controllerFloat.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: new Icon(_controllerFloat.isDismissed
                          ? Icons.add
                          : Icons.close),
                    );
                  },
                ),
                onPressed: () {
                  if (_controllerFloat.isDismissed) {
                    _controllerFloat.forward();
                  } else {
                    _controllerFloat.reverse();
                  }
                },
              ),
            ),
          ),
      ),
      body: _testQuestions.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Text(
                "No Question",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    headingRow(),
                    questionRow(),
                    questionNoRow(),
                    buttonRow()
                  ],
                ),
              ),
            ),
    );
  }

  Widget headingRow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.4),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1))
          ]),
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 5 / 10,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black87),
                borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.only(left: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _testName,
                isDense: true,
                dropdownColor: Colors.white,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
                iconEnabledColor: Colors.black87,
                items: <String>[_testName].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _testName = value;
                  });
                },
              ),
            ),
          ),
          Spacer(),
          Icon(Icons.timer),
          SizedBox(
            width: 3,
          ),
          Expanded(
              child: Text(
            _FORMATTED_TEST_DURATION,
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ))
        ],
      ),
    );
  }

  Widget questionRow() {
    return Container(
      height: MediaQuery.of(context).size.height * 6.6 / 10,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(1),
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _noOFQuestions,
        onPageChanged: (i) {
          HapticFeedback.selectionClick();
          _controllerList.animateToPage(i,
              curve: Curves.decelerate, duration: Duration(milliseconds: 300));
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
            //-------------------//
            if (i != 0) {
              _questionTiming.update(_testQuestions[i - 1]['sno'].toString(),
                  (value) => value + _questionTime,
                  ifAbsent: () => _questionTime);
              _questionTime = 0;
            }
          });
        },
        itemBuilder: (context, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9999,
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
                              if (_bookmarkMap[_testQuestions[i]['sno']] ==
                                  "true") {
                                reviewLater = false;
//                                  _bookmarkMap.update(_testData[i]['sno'], (value) => "false",ifAbsent: () => "false",);
                                _bookmarkMap.remove(_testQuestions[i]['sno']);
                              } else {
                                reviewLater = true;
                                _bookmarkMap.update(
                                  _testQuestions[i]['sno'],
                                  (value) => "true",
                                  ifAbsent: () => "true",
                                );
                              }
                              //
                            });
                          },
                          value:
                              _bookmarkMap[_testQuestions[i]['sno']] == "true"
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
                      height: MediaQuery.of(context).size.height * 4.5 / 10,
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(
                              child: Image.memory(
                                  base64.decode(
                                      _testQuestions[i]['encodedImage'] == null
                                          ? ""
                                          : _testQuestions[i]['encodedImage']),
                                  gaplessPlayback: true),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 1 / 10,
                      child: ListView.builder(
                        itemCount: int.parse(_testQuestions[i]['noOfOptions']),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, j) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _answerMap.update(
                                    _testQuestions[i]['sno'],
                                    (value) => j + 1,
                                    ifAbsent: () => j + 1,
                                  );
                                });
                              },
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 2 / 10,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: _answerMap[
                                                          _testQuestions[i]
                                                              ['sno']] !=
                                                      j + 1
                                                  ? Colors.white
                                                  : Colors.green)),
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
                                                        _testQuestions[i]
                                                            ['sno']] !=
                                                    j + 1
                                                ? Colors.grey
                                                : Colors.green,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              child: Text((j + 1).toString()))
                                        ],
                                      ),
                                    ),
//                                    Divider(height: 1,color: _answerMap[_testData[i]['sno']]!=j+1?Colors.grey:Colors.green,thickness: 3,)
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
    );
  }

  Widget questionNoRow() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * 0.9 / 10,
        width: MediaQuery.of(context).size.width * 8 / 10,
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
                  decoration: BoxDecoration(
                    color: _answerMap[_testQuestions[i]['sno']] == null
                        ? _bookmarkMap.containsKey(_testQuestions[i]['sno'])
                            ? Colors.blue
                            : Colors.white
                        : _bookmarkMap.containsKey(_testQuestions[i]['sno'])
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

  _floatingButtonClick(int index) async {
    _controllerFloat.reverse();
    if (index == 0) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(_testName, jsonEncode(_questionTiming));
      print(_questionTiming);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TestSummary(_testQuestions, _answerMap,
            _bookmarkMap, _FORMATTED_TEST_DURATION, sno, testType),
      ));
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }
}
