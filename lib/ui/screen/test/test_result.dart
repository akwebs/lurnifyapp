import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/ui/home_page.dart';
import 'package:lurnify/ui/screen/test/solution.dart';
import 'package:lurnify/widgets/componants/progress_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

class TestResult extends StatefulWidget {
  final int _correctQuestion, _wrongAnswer, _resultNumber;
  final List _testData;
  final Map _answerMap, _bookmarkMap;
  final _FORMATTED_TEST_DURATION;
  TestResult(this._correctQuestion, this._wrongAnswer, this._resultNumber, this._testData, this._answerMap, this._bookmarkMap, this._FORMATTED_TEST_DURATION);
  @override
  _TestResultState createState() => _TestResultState(_correctQuestion, _wrongAnswer, _resultNumber, _testData, _answerMap, _bookmarkMap);
}

class _TestResultState extends State<TestResult> with SingleTickerProviderStateMixin {
  final _correctQuestion, _wrongAnswer, _resultNumber;
  final List _testData;
  final Map _answerMap, _bookmarkMap;
  _TestResultState(this._correctQuestion, this._wrongAnswer, this._resultNumber, this._testData, this._answerMap, this._bookmarkMap);
  TabController _tabController;
  Timer _timer;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text("Result"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              })
        ],
        bottom: TabBar(
          tabs: const [
            Tab(
              child: Text("Score"),
            ),
            Tab(
              child: Text("Analysis"),
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [resultCard(), messageCard()],
            ),
          ),
          Solution(_answerMap, _bookmarkMap, _testData, widget._FORMATTED_TEST_DURATION),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget resultCard() {
    double width = context.screenWidth;
    return [
      [
        CircularPercentIndicator(
          radius: width * 0.5,
          lineWidth: 10.0,
          animation: true,
          percent: (_resultNumber / (_testData.length * 4)) < 0 ? 0 : _resultNumber / (_testData.length * 4),
          center: [
            "$_resultNumber".text.xl2.make(),
            Container(
              height: 1.5,
              width: 40,
              color: Colors.black54,
            ),
            Text((_testData.length * 4).toString()).text.xl2.make()
          ].vStack(),
          backgroundColor: const Color.fromARGB(30, 128, 112, 254),
          circularStrokeCap: CircularStrokeCap.round,
          linearGradient: const LinearGradient(colors: <Color>[Colors.deepPurpleAccent, Colors.deepPurple], stops: <double>[0.25, 0.75]),
        ).p12(),
        Text((_resultNumber / (_testData.length * 4) * 100).toStringAsFixed(0) + "%").text.xl4.purple900.semiBold.makeCentered().expand()
      ].hStack().card.make().p8(),
      [
        [
          const Icon(
            Icons.check,
            color: Colors.green,
            size: 18,
          ),
          Text("$_correctQuestion Correct").text.sm.make(),
        ].hStack(),
        10.widthBox,
        [
          const Icon(
            Icons.cancel,
            size: 18,
            color: Colors.red,
          ),
          Text("$_wrongAnswer Incorrect").text.sm.make(),
        ].hStack(),
        10.widthBox,
        [
          const Icon(
            Icons.radio_button_unchecked,
            size: 18,
            color: Colors.grey,
          ),
          Text((_testData.length - (_wrongAnswer + _correctQuestion)).toString() + " Unattempted").text.sm.make(),
        ].hStack(),
      ].hStack().p8(),
      TextButton(
        onPressed: () {
          Share.share(
            'Hey Check My Score in Lurnify Test $_resultNumber out of ' + (_testData.length * 4).toString(),
          );
        },
        child: [
          const Icon(Icons.share_rounded),
          "SHARE YOUR SCORE".text.make(),
        ].hStack(),
      ).p12()
    ].vStack();
  }

  Widget messageCard() {
    return [
      [
        const Icon(
          Icons.style,
        ),
        const SizedBox(
          width: 5,
        ),
        "Suggestion from experts : ".text.semiBold.make()
      ].hStack(alignment: MainAxisAlignment.start),
      const Divider(
        color: Colors.grey,
      ),
      [
        const Icon(
          Icons.person,
          size: 40,
        ).p8(),
        "Dear Student, Attempt more question to improve your score, the more you attempt the more you get!".text.make().p8().expand(),
      ].hStack(),
    ].vStack().card.make().p8();
  }

  Future<void> _showDailyAppOpening() async {
    String testAttempt = "0";
    String testScore = "0";
    DBHelper dbHelper = DBHelper();
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> list = await db.rawQuery('select testAttempt,testScore from reward order by sno desc limit 1');
    for (var a in list) {
      testAttempt = a['testAttempt'] ?? '0';
      testScore = a['testScore'] ?? '0';
    }
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: "You earn $testAttempt dimes for attempting "
          "test and \n $testScore for scoring in test.\n Total dimes "
          "earn in this test is ${(int.parse(testScore) + int.parse(testAttempt)).toString()}.",
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {},
    )..show();
  }
}
