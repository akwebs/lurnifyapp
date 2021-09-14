import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/test/test.dart';

class RankboosterInstruction extends StatefulWidget {
  final String testDuration;
  final String marks;
  final Map<String, dynamic> _selectedSubjectMap;
  final String selectedSwitchOption;
  final String levelOfDifficulty;
  final String _noOfQuestion;
  RankboosterInstruction(
      this.testDuration,
      this.marks,
      this._selectedSubjectMap,
      this.selectedSwitchOption,
      this.levelOfDifficulty,
      this._noOfQuestion);
  @override
  _RankboosterInstructionState createState() => _RankboosterInstructionState(
      testDuration,
      marks,
      _selectedSubjectMap,
      selectedSwitchOption,
      levelOfDifficulty,
      _noOfQuestion);
}

class _RankboosterInstructionState extends State<RankboosterInstruction> {
  final String testDuration;
  final String marks;
  final Map<String, dynamic> _selectedSubjectMap;
  final String selectedSwitchOption;
  final String levelOfDifficulty;
  final String _noOfQuestion;
  _RankboosterInstructionState(
      this.testDuration,
      this.marks,
      this._selectedSubjectMap,
      this.selectedSwitchOption,
      this.levelOfDifficulty,
      this._noOfQuestion);

  Map<String, dynamic> _testData = Map();

  _getTestData() async {
    try {
      String testData = jsonEncode(_selectedSubjectMap);
      // ignore: unused_local_variable
      String testDuration = "";
      if (selectedSwitchOption == "Numerical") {
        testDuration =
            (_selectedSubjectMap.length * int.parse(_noOfQuestion) * 2)
                .round()
                .toString();
      } else {
        testDuration =
            (_selectedSubjectMap.length * int.parse(_noOfQuestion).round())
                .toString();
      }
      var url = baseUrl +
          "createRankBoosterTest?questionType=" +
          selectedSwitchOption.toLowerCase() +
          "&difficulty=" +
          levelOfDifficulty.toLowerCase() +
          "&noOfQuestions=" +
          _noOfQuestion;
      print(url);
      print(testData);
      http.Response response =
          await http.post(Uri.encodeFull(url), body: testData);
      var resbody = jsonDecode(response.body);
      _testData = resbody;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instructions"),
      ),
      body: FutureBuilder(
          future: _getTestData(),
          builder: (context, snapshot) {
            return Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_right, size: 20),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            "There will be $_noOfQuestion questions in this test")
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.arrow_right, size: 20),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Each question of marks $marks ")
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.arrow_right, size: 20),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Total time will be $testDuration ")
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Start",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      color: Colors.deepPurpleAccent,
                      splashColor: Colors.black87,
                      onPressed: () => _startTest(),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  _startTest() {
    if (_testData.isEmpty) {
      toastMethod("Please wait a while. we are loading your test");
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            Test(_testData, "rankBoosterTest", "", "", "", "", ""),
      ));
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
