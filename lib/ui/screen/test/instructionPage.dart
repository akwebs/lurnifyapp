import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/test/test.dart';
import 'package:lurnify/widgets/componants/custom-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class InstructionPage extends StatefulWidget {
  final String sno;
  InstructionPage(this.sno);
  @override
  _InstructionPageState createState() => _InstructionPageState(sno);
}

class _InstructionPageState extends State<InstructionPage> {
  final String sno;
  _InstructionPageState(this.sno);
  bool check = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> _instructions = Map();
  List _instructionData = [];
  var _data;
  Timer _timer;
  Map<String, dynamic> _testData = Map();
  int _testAttempt = 0;

  Future getInstructions() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl +
          "getInstructionPageByTopic?topicSno=" +
          sno +
          "&registerSno=" +
          sp.getString("studentSno");
      print(url);
      http.Response response = await http.get(Uri.encodeFull(url));
      print(response);
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      _instructions = responseBody['instruction'];
      _instructionData = _instructions['instructionData'];
      _testAttempt = responseBody['testAttempt'];
      _showDailyAppOpening();
    } catch (e) {
      print(e);
    }
  }

  Future _getTestData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl +
        "getTestByTopic?topicSno=" +
        sno +
        "&registerSno=" +
        sp.getString("studentSno");
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
    _timer = new Timer(Duration(seconds: 2), () {
      _getTestData();
    });
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
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: _instructionData.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.all(3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.arrow_right, size: 20),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    _instructionData[i]['instructions'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // CustomButton(
                      //   buttonText: 'Start',
                      //   onPressed: () => _startTest(),
                      //   verpad: EdgeInsets.symmetric(vertical: 10),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        onPressed: () => _startTest(),
        icon: const Icon(Icons.arrow_forward_ios_rounded),
        label: const Text('Start'),
      ),
    );
  }

  _startTest() {
    if (_testData.isEmpty) {
      toastMethod("Please wait a while. we are loading your test");
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Test(_testData, "topicTest", sno),
      ));
    }
  }

  _failed() {
    final snackBar = SnackBar(
      content: Text('Failed. Test Already Done'),
    );
    ScaffoldMessenger.of(_scaffoldKey.currentState.context)
        .showSnackBar(snackBar);
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

  Future<void> _showDailyAppOpening() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: "You can earn " +
          _testAttempt.toString() +
          " dimes as test attempt reward. Please complete the test.",
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {},
    )..show();
  }
}
