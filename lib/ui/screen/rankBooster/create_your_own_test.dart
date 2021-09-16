import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/rankBooster/rankbooster_instruction.dart';
import 'package:lurnify/ui/screen/test/test.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:material_switch/material_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateYourOwnTest extends StatefulWidget {
  @override
  _CreateYourOwnTestState createState() => _CreateYourOwnTestState();
}

class _CreateYourOwnTestState extends State<CreateYourOwnTest> {
  List<String> switchOptions = ["Numerical", "Formula"];
  String selectedSwitchOption = "Numerical";
  // String testDuration="10";
  String _noOfQuestion = "10";
  String levelOfDifficulty = "Easy";
  List _completedChapters = [];
  var data;
  Map<int, bool> _checkBoxMap = Map();
  Map<String, String> _selectedSubjectMap = Map();

  Future _getCompletedChapters() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl + "getCompletedChaptersByReg?regSno=" + sp.getString("studentSno");
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      _completedChapters = resbody;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    data = _getCompletedChapters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Create your own test',
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Material(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.deepPurple,
                                        padding: const EdgeInsets.all(4.0),
                                      ),
                                      testOptions(),
                                      chaptersSelection(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        buttonText: 'Done',
        verpad: EdgeInsets.symmetric(vertical: 15),
        onPressed: () {
          _navigateToInstructionPage();
        },
      ),
    );
  }

  Widget testOptions() {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    MaterialSwitch(
                      selectedOption: selectedSwitchOption,
                      options: switchOptions,
                      selectedBackgroundColor: firstColor,
                      selectedTextColor: Colors.white,
                      onSelect: (String selectedOption) {
                        setState(() {
                          selectedSwitchOption = selectedOption;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "No. of question per subject :  ",
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(border: Border.all(color: Colors.blue[100]), borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _noOfQuestion,
                              isDense: true,
                              items: <String>['5', '10', '20', '30', '40'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _noOfQuestion = value;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Level of Difficulty :  ",
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(border: Border.all(color: Colors.blue[100]), borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: levelOfDifficulty,
                              isDense: true,
                              items: <String>['Easy', 'Medium', 'Difficulty', 'Random'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  levelOfDifficulty = value;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: firstColor, width: 1)),
                        child: selectedSwitchOption == "Numerical"
                            ? Text(
                                "Total time will be " + (_selectedSubjectMap.length * int.parse(_noOfQuestion) * 2).toString(),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )
                            : Text(
                                "Total time will be " + (_selectedSubjectMap.length * int.parse(_noOfQuestion)).toString(),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget chaptersSelection() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: ListView.builder(
          itemCount: _completedChapters.length,
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, i) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    _completedChapters[i]['subjectName'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  children: [
                    ListView.builder(
                      itemCount: _completedChapters[i]['completedChapSubs'].length,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, j) {
                        _checkBoxMap.putIfAbsent(_completedChapters[i]['completedChapSubs'][j]['sno'], () => false);
                        return Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: _checkBoxMap[_completedChapters[i]['completedChapSubs'][j]['sno']],
                                title: Text(_completedChapters[i]['completedChapSubs'][j]['chapterName']),
                                onChanged: (newValue) {
                                  setState(() {
                                    _checkBoxMap[_completedChapters[i]['completedChapSubs'][j]['sno']] = newValue;
                                    if (newValue) {
                                      _addToSubjectMap(_completedChapters[i]['sno'], _completedChapters[i]['completedChapSubs'][j]['sno']);
                                    } else {
                                      _removeFromSubjectMap(_completedChapters[i]['sno'], _completedChapters[i]['completedChapSubs'][j]['sno']);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _addToSubjectMap(int i, int sno) {
    _selectedSubjectMap.update(
      i.toString(),
      (value) => value + "," + sno.toString(),
      ifAbsent: () => sno.toString(),
    );
  }

  _removeFromSubjectMap(int i, int sno) {
    print(_selectedSubjectMap);
    String value = _selectedSubjectMap[i.toString()];
    print(value);
    if (value.contains(",")) {
      List valueList = value.split(",");
      valueList.remove(sno.toString());
      String newValue = "";
      for (var a in valueList) {
        if (newValue.length > 0) {
          newValue = newValue + "," + a;
        } else {
          newValue = a;
        }
      }
      _selectedSubjectMap[i.toString()] = newValue;
    } else {
      _selectedSubjectMap.remove(i.toString());
    }
  }

  _navigateToInstructionPage() {
    String testDuration = "";
    if (selectedSwitchOption == "Numerical") {
      testDuration = (_selectedSubjectMap.length * int.parse(_noOfQuestion) * 2).round().toString();
    } else {
      testDuration = (_selectedSubjectMap.length * int.parse(_noOfQuestion).round()).toString();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => RankboosterInstruction(testDuration, "4", _selectedSubjectMap, selectedSwitchOption, levelOfDifficulty, _noOfQuestion),
    ));
  }

  // ignore: unused_element
  Future _submit() async {
    try {
      String testData = jsonEncode(_selectedSubjectMap);
      String noOfQuestions = "";
      if (selectedSwitchOption == "Numerical") {
        noOfQuestions = (_selectedSubjectMap.length * int.parse(_noOfQuestion) * 2).round().toString();
      } else {
        noOfQuestions = (_selectedSubjectMap.length * int.parse(_noOfQuestion).round()).toString();
      }
      var url = baseUrl + "createRankBoosterTest?questionType=" + selectedSwitchOption + "&difficulty=" + levelOfDifficulty + "&noOfQuestions=" + noOfQuestions;
      print(url);
      http.Response response = await http.post(Uri.encodeFull(url), body: testData);
      var resbody = jsonDecode(response.body);
      Map<String, dynamic> map = resbody;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Test(map, "rankBoosterTest", "", "", "", "", ""),
      ));
    } catch (e) {
      print(e);
    }
  }
}
