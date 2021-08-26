import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/ui/screen/test/solution.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:share/share.dart';

class TestResult extends StatefulWidget {
  final int _correctQuestion, _wrongAnswer, _resultNumber;
  final List _testData;
  final Map _answerMap, _bookmarkMap, response;
  TestResult(this._correctQuestion, this._wrongAnswer, this._resultNumber,
      this._testData, this._answerMap, this._bookmarkMap, this.response);
  @override
  _TestResultState createState() => _TestResultState(
      _correctQuestion,
      _wrongAnswer,
      _resultNumber,
      _testData,
      _answerMap,
      _bookmarkMap,
      response);
}

class _TestResultState extends State<TestResult>
    with SingleTickerProviderStateMixin {
  final _correctQuestion, _wrongAnswer, _resultNumber;
  final List _testData;
  final Map _answerMap, _bookmarkMap, _response;
  _TestResultState(this._correctQuestion, this._wrongAnswer, this._resultNumber,
      this._testData, this._answerMap, this._bookmarkMap, this._response);
  TabController _tabController;
  Timer _timer;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    _timer = Timer(Duration(seconds: 1), () {
      _showDailyAppOpening();
    });
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
        title: Text("Result"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
              })
        ],
        bottom: TabBar(
          tabs: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Tab(
                  child: Text("Score"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Tab(
                  child: Text("Analysis"),
                ),
              ],
            )
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [resultCard(), messageCard()],
              ),
            ),
          ),
          Solution(_answerMap, _bookmarkMap, _testData),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget resultCard() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 1))
            ]),
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 150.0,
                      lineWidth: 8.0,
                      percent: (_resultNumber / (_testData.length * 4)) < 0
                          ? 0
                          : _resultNumber / (_testData.length * 4),
                      animateFromLastPercent: true,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$_resultNumber",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            height: 1.5,
                            width: 40,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text((_testData.length * 4).toString(),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20))
                        ],
                      ),
                      progressColor: Colors.green,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("$_correctQuestion Correct"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("$_wrongAnswer Incorrect"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text((_testData.length -
                                    (_wrongAnswer + _correctQuestion))
                                .toString() +
                            " Unattempted"),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Share.share(
                  'Hey Check My Score in Lurnify Test ' +
                      "$_resultNumber" +
                      ' out of ' +
                      (_testData.length * 4).toString(),
                );
              },
              child: Text("SHARE YOUR SCORE"),
            )
          ],
        ),
      ),
    );
  }

  Widget messageCard() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.style,
                  color: Colors.deepPurpleAccent,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "SSS Suggest : ",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.deepPurpleAccent,
                ),
                Expanded(
                  child: Text(
                    "Dear Student, Attempt more question to improve your score, the more you attempt the more you get! ",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                      letterSpacing: 0.6,
                      wordSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showDailyAppOpening() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: "You earn " +
          _response['testAttempt'].toString() +
          " dimes for attempting "
              "test and \n " +
          _response['testScore'].toString() +
          " for scoring in test.\n Total dimes "
              "earn in this test is " +
          (_response['testScore'] + _response['testAttempt']).toString() +
          ".",
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {},
    )..show();
  }
}
