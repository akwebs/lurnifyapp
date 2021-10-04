// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/test/test_summary.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  final Map<String, dynamic> testData;
  final String testType;
  final sno, course, subject, unit, chapter;
  const Test(this.testData, this.testType, this.sno, this.course, this.subject, this.unit, this.chapter, {Key key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  _TestState createState() => _TestState(testData, testType, sno, course, subject, unit, chapter);
}

class _TestState extends State<Test> with TickerProviderStateMixin {
  final Map<String, dynamic> testData;
  final String testType, sno, course, subject, unit, chapter;
  _TestState(this.testData, this.testType, this.sno, this.course, this.subject, this.unit, this.chapter);
  int _index = 0, _currentPageIndex = 0;
  bool reviewLater = false;
  int selectedOptionIndex;
  Timer _timer;
  int _TEST_TIMER_INSECONDS = 600;
  // int _questionTime = 0;
  String _FORMATTED_TEST_DURATION = "";
  int _noOFQuestions;
  bool _isFirstQuestion = true;
  bool _isLastQuestion = false;
  final PageController _controller = PageController(viewportFraction: 1, keepPage: true);
  final PageController _controllerList = PageController(viewportFraction: 0.083, keepPage: true);
  AnimationController _controllerFloat;
  final Map _answerMap = Map();
  final Map _bookmarkMap = Map();
  String _toolBarName = "";
  String _testName = "";
  List _testQuestions = [];
  int _totalSecond = 0;
  final Map<String, int> _questionTiming = Map();
  static const List<IconData> icons = const [
    Icons.check_circle_outline,
    Icons.info_outline,
    Icons.format_align_left_rounded,
  ];
  static const List<String> iconsText = const ["Submit", "Current Section Instruction", "Test Instruction"];
  DateTime _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press BACK again to exit Test', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

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
  final message = const [
    SnackBar(
      content: Text('This is first Question!'),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ),
    SnackBar(
      content: Text('This is last Question!'),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      elevation: 1000,
    ),
  ];
  // Future _getRankBoosterTestData()async{
  //   _testQuestions=list[0]['test'];
  //   setState(() {
  //     _noOFQuestions = _testQuestions.length;
  //     _toolBarName = "Rank Booster Test";
  //     _testName = "Rank Booster Test";
  //   });
  // }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_TEST_TIMER_INSECONDS < 1) {
            timer.cancel();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TestSummary(_testQuestions, _answerMap, _bookmarkMap, _FORMATTED_TEST_DURATION, sno, testType, course, subject, unit, chapter, _totalSecond, _questionTiming),
              ),
            );
          } else {
            _totalSecond = _totalSecond + 1;
            _TEST_TIMER_INSECONDS = _TEST_TIMER_INSECONDS - 1;
            _FORMATTED_TEST_DURATION = _formatDuration(Duration(seconds: _TEST_TIMER_INSECONDS));
            // _questionTime = _questionTime + 1;

            _questionTiming.update(_testQuestions[_currentPageIndex]['sno'].toString(), (value) => value + 1, ifAbsent: () => 1);
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
    print("---------------------------------------------");
    print(testData['topicTestTime']);
    if (testData['test'] != null) {
      _testQuestions = testData['test'] ?? [];
      _toolBarName = testData['testName'] ?? "";
      _testName = testData['testName'] ?? '';
      _TEST_TIMER_INSECONDS = int.tryParse(testData['topicTestTime']) ?? 600;
      if (_TEST_TIMER_INSECONDS == 0) {
        _TEST_TIMER_INSECONDS = 600;
      }
    }
    print(_testQuestions);
    if (_testQuestions != null) {
      _noOFQuestions = _testQuestions.length;
    }
    startTimer();
    _controllerFloat = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
    double height = context.screenHeight;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.1),
        child: AppBar(
          title: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _testName,
              iconEnabledColor: firstColor,
              isDense: true,
              style: TextStyle(
                color: firstColor,
                fontWeight: FontWeight.w600,
              ),
              items: <String>[_testName].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _testName = value;
                });
              },
            ),
          ).px8(),
          centerTitle: true,
          elevation: 0,
          actions: [_FORMATTED_TEST_DURATION.text.lg.semiBold.align(TextAlign.end).makeCentered().px8()],
          // bottom: PreferredSize(
          //   child: questionsNoList().px8(),
          //   preferredSize: Size.fromHeight(height * 0.1),
          // ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 8,
              mainAxisExtent: 30,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            controller: _controllerList,
            padding: const EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
            itemCount: _noOFQuestions,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: GestureDetector(
                  onTap: () {
                    _controller.animateToPage(i, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                  },
                  child: Container(
                    height: 25,
                    width: 25,
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
                    child: Center(
                        child: Text(
                      (i + 1).toString(),
                      style: TextStyle(color: Colors.black87),
                    )),
                  ),
                ),
              );
            },
          ).p8(),
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: _testQuestions.isEmpty
              ? Center(
                  child: "No Question".text.xl.make(),
                )
              : questionRow(),
        ),
      ),
      bottomNavigationBar: [
        PreferredSize(
          child: questionsNoList().px8(),
          preferredSize: Size.fromHeight(height * 0.1),
        ),
        [
          CustomButton(
            brdRds: 0,
            buttonText: 'Previous',
            verpad: const EdgeInsets.symmetric(vertical: 5),
            onPressed: () {
              if (_isFirstQuestion) {
                ScaffoldMessenger.of(context).showSnackBar(message[0]);
              } else {
                _controller.animateToPage(_index - 1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                if (_index > 10) {
                  _controllerList.animateToPage(_index - 1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                }
              }
            },
          ).expand(),
          1.widthBox,
          CustomButton(
            brdRds: 0,
            buttonText: 'Next',
            verpad: const EdgeInsets.symmetric(vertical: 5),
            onPressed: () {
              if (_isLastQuestion) {
                ScaffoldMessenger.of(context).showSnackBar(message[1]);
              } else {
                _controller.animateToPage(_index + 1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                if (_index > 10) {
                  _controllerList.animateToPage(_index - 1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                }
              }
            },
          ).expand(),
        ].hStack(),
      ].vStack(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(icons.length, (int index) {
          Widget child = Container(
            height: 70.0,
//            width: 110.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controllerFloat,
                  curve: Interval(0.0, 1.0 - index / icons.length / 2.0, curve: Curves.fastOutSlowIn),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        iconsText[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: firstColor,
                      mini: true,
                      heroTag: null,
                      child: Icon(icons[index], color: Colors.white),
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
            FloatingActionButton(
              heroTag: null,
              backgroundColor: firstColor,
              child: AnimatedBuilder(
                animation: _controllerFloat,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: Matrix4.rotationZ(_controllerFloat.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(_controllerFloat.isDismissed ? Icons.add : Icons.close),
                  );
                },
              ),
              foregroundColor: whiteColor,
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
    );
  }

  Widget questionRow() {
    double height = context.screenHeight;
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.horizontal,
      itemCount: _noOFQuestions,
      onPageChanged: (i) {
        _currentPageIndex = i;
        HapticFeedback.selectionClick();
        if (i > 10) {
          _controllerList.animateToPage(i, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
        }
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
        });
      },
      itemBuilder: (context, i) {
        return Transform.scale(
          scale: i == _index ? 1 : 0.9999,
          transformHitTests: true,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              color: whiteColor,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (i + 1).text.white.lg.makeCentered().box.color(firstColor).make().h(25).w(25),
                        10.widthBox,
                        [
                          const Icon(
                            Icons.check,
                            color: Vx.white,
                            size: 15,
                          ).box.color(Vx.green600).roundedFull.make().h(25).w(25),
                          '4'.text.lg.black.makeCentered().box.make().h(25).w(25),
                        ].hStack(),
                        10.widthBox,
                        [
                          const Icon(
                            Icons.close,
                            color: Vx.white,
                            size: 15,
                          ).box.color(Vx.red600).roundedFull.make().h(25).w(25),
                          '1'.text.lg.black.makeCentered().box.make().h(25).w(25),
                        ].hStack(),
                        const Spacer(),
                        "Review Later".text.lg.semiBold.black.make(),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Checkbox(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: firstColor,
                            checkColor: whiteColor,
                            onChanged: (value) {
                              setState(() {
                                if (_bookmarkMap[_testQuestions[i]['sno']] == "true") {
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
                            value: _bookmarkMap[_testQuestions[i]['sno']] == "true" ? true : false,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Vx.gray400,
                      height: 20,
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Image.memory(base64.decode(_testQuestions[i]['encodedImage'] ?? ""), gaplessPlayback: true),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.2,
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
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 2 / 10,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _answerMap[_testQuestions[i]['sno']] != j + 1 ? Colors.transparent : Colors.green),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: _answerMap[_testQuestions[i]['sno']] != j + 1 ? Colors.white : Colors.green,
                                        child: Text(
                                          (j + 1).toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: _answerMap[_testQuestions[i]['sno']] != j + 1 ? firstColor : whiteColor,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 8.0,
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
//                                    Divider(height: 1,color: _answerMap[_testData[i]['sno']]!=j+1?Colors.grey:Colors.green,thickness: 3,)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget questionNoRow() {
  //   return Container(
  //     padding: EdgeInsets.all(5),
  //     height: MediaQuery.of(context).size.height * 0.5 / 10,
  //     width: MediaQuery.of(context).size.width,
  //     child: PageView.builder(
  //       controller: _controllerList,
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _noOFQuestions,
  //       dragStartBehavior: DragStartBehavior.start,
  //       physics: BouncingScrollPhysics(),
  //       itemBuilder: (context, i) {
  //         return Padding(
  //           padding: EdgeInsets.only(left: 10, top: 5),
  //           child: GestureDetector(
  //             onTap: () {
  //               _controller.animateToPage(i,
  //                   curve: Curves.decelerate,
  //                   duration: Duration(milliseconds: 300));
  //             },
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: _answerMap[_testQuestions[i]['sno']] == null
  //                     ? _bookmarkMap.containsKey(_testQuestions[i]['sno'])
  //                         ? Colors.blue
  //                         : Colors.white
  //                     : _bookmarkMap.containsKey(_testQuestions[i]['sno'])
  //                         ? Colors.blue
  //                         : Colors.green,
  //                 border: Border.all(color: Colors.black54),
  //                 borderRadius: BorderRadius.circular(3),
  //               ),
  //               child: Center(child: Text((i + 1).toString())),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget questionsNoList() {
    return ListView.builder(
      controller: _controllerList,
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.horizontal,
      itemCount: _noOFQuestions,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child: GestureDetector(
            onTap: () {
              _controller.animateToPage(i, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
            },
            child: Container(
              height: 25,
              width: 25,
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
              child: Center(
                  child: Text(
                (i + 1).toString(),
                style: TextStyle(color: Colors.black87),
              )),
            ),
          ),
        );
      },
    ).h(40).box.make();
  }

  _floatingButtonClick(int index) async {
    _controllerFloat.reverse();
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TestSummary(_testQuestions, _answerMap, _bookmarkMap, _FORMATTED_TEST_DURATION, sno, testType, course, subject, unit, chapter, _totalSecond, _questionTiming),
        ),
      );
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => TestSummary(_testQuestions, _answerMap, _bookmarkMap, _FORMATTED_TEST_DURATION, sno, testType, course, subject, unit, chapter, _totalSecond, _questionTiming),
      //   ),
      // );
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 12.0);
  }
}
