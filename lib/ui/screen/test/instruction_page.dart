import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/helper/reward_repo.dart';
import 'package:lurnify/helper/instruction_repo.dart';
import 'package:lurnify/helper/instruction_repo_data.dart';
import 'package:lurnify/helper/test_main_repo.dart';
import 'package:lurnify/helper/test_repo.dart';
import 'package:lurnify/model/test_main.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/test/test.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sqflite/sqflite.dart';

class InstructionPage extends StatefulWidget {
  final String course, subject, unit, chapter, sno;
  const InstructionPage(this.course, this.subject, this.unit, this.chapter, this.sno, {Key key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  _InstructionPageState createState() => _InstructionPageState(course, subject, unit, chapter, sno);
}

class _InstructionPageState extends State<InstructionPage> {
  final String course, subject, unit, chapter, sno;
  _InstructionPageState(this.course, this.subject, this.unit, this.chapter, this.sno);
  bool check = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Map<String, dynamic> _instructions = Map();
  List _instructionData = [];
  var _data;
  // Timer _timer;
  Map<String, dynamic> _testData = Map();
  int _testAttempt = 0;
  List<Map<String, dynamic>> _testList = [];

  Future getInstructions() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      TestMainRepo testMainRepo = TestMainRepo();
      _testList = await testMainRepo.findByTopicAndRegister(sno, sp.getString("studentSno"));
      print(_testList);
      if (_testList == null || _testList.isEmpty) {
        print('if');
        List<TestMain> testMain = [];
        var url = baseUrl + "getTestByTopicV2?topicSno=" + sno;
        print(url);
        http.Response response = await http.post(Uri.encodeFull(url));
        print(response);
        testMain = (jsonDecode(response.body) as List).map((e) => TestMain.fromJson(e)).toList();

        DBHelper dbHelper = DBHelper();
        Database db = await dbHelper.database;
        await db.transaction((txn) async {
          for (var a in testMain) {
            InstructionRepo instructionRepo = InstructionRepo();
            instructionRepo.insertIntoInstruction(a.instruction, txn);
            print("Instruction Inserted");

            InstructionDataRepo instructionDataRepo = InstructionDataRepo();
            for (var b in a.instruction.instructionData) {
              instructionDataRepo.insertIntoInstructionData(b, a.instruction.sno.toString(), txn);
              print("Instruction Data Inserted");
            }

            TestMainRepo testMainRepo = TestMainRepo();
            testMainRepo.insertIntoTestMain(a, txn);
            print("TestMain Inserted");

            for (var c in a.test) {
              TestRepo testRepo = TestRepo();
              c.testMain = a.sno.toString();
              testRepo.insertIntoTest(c, txn);
              print("Test Inserted");
            }
          }
        }).whenComplete(() async {
          _testList = await testMainRepo.findByTopicAndRegister(sno, sp.getString("studentSno"));
          await _getTestFromLocal();
        });
      } else {
        _getTestFromLocal();
        print('else');
      }

      RewardRepo rewardRepo = RewardRepo();
      List<Map<String, dynamic>> reward = await rewardRepo.getReward();
      for (var a in reward) {
        String tAttempt=a['testAttempt'] ?? '0';
        _testAttempt = int.parse(tAttempt);
      }
      // if (responseBody['testAttempt'] != null) {
      //   _testAttempt = responseBody['testAttempt'];
      // }

      _showDailyAppOpening();
    } catch (e) {
      print(e);
    }
  }

  Future _getTestFromLocal() async {
    for (var a in _testList) {
      var insSno = a['instruction'];
      // _instructions=a;
      InstructionRepo instructionRepo = InstructionRepo();
      List<Map<String, dynamic>> list = await instructionRepo.getInstructionBySno(insSno);
      for (var b in list) {
        InstructionDataRepo instructionDataRepo = InstructionDataRepo();
        List<Map<String, dynamic>> list2 = await instructionDataRepo.getInstructionDataByInstruction(b['sno'].toString());
        _instructionData = list2;
      }
    }
    for (var i = 0; i < _testList.length; i++) {
      TestRepo testRepo = TestRepo();
      List<Map<String, dynamic>> list = await testRepo.getTestByTestMain(_testList[i]['sno'].toString());
      _testData.update(
        'testName',
        (value) => _testList[i]['testName'],
        ifAbsent: () => _testList[i]['testName'],
      );
      _testData.update(
        'topicTestTime',
        (value) => _testList[i]['topicTestTime'],
        ifAbsent: () => _testList[i]['topicTestTime'],
      );
      _testData.update(
        'test',
        (value) => list,
        ifAbsent: () => list,
      );
    }
    return null;
  }

  Future _getTestData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl + "getTestByTopic?topicSno=" + sno + "&registerSno=" + sp.getString("studentSno");
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var responseData = jsonDecode(response.body);
    _testData = responseData;
  }

  @override
  void initState() {
    _data = getInstructions();
    // _timer = new Timer(Duration(seconds: 2), () {
    //   _getTestData();
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Instructions"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: _instructionData.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.arrow_right, size: 20),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    _instructionData[i]['instructions'],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.6),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
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
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        buttonText: 'Start Test',
        onPressed: () {
          _startTest();
        },
        verpad: const EdgeInsets.symmetric(vertical: 5),
      ),
    );
  }

  _startTest() {
    if (_testData.isEmpty) {
      toastMethod("Please wait a while. we are loading your test");
    } else if (_testData == null) {
      toastMethod("Sorry no data");
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Test(_testData, "topicTest", sno, course, subject, unit, chapter),
      ));
    }
  }

  // ignore: unused_element
  _failed() {
    const snackBar = SnackBar(
      content: Text('Failed. Test Already Done'),
    );
    ScaffoldMessenger.of(_scaffoldKey.currentState.context).showSnackBar(snackBar);
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 18.0);
  }

  Future<void> _showDailyAppOpening() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: "You can earn " + _testAttempt.toString() + " dimes as test attempt reward. Please complete the test.",
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {},
    )..show();
  }
}
