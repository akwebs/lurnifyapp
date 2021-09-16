import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';

class Solution extends StatefulWidget {
  final Map _answerMap, _bookmarkMap;
  final List _testData;

  const Solution(this._answerMap, this._bookmarkMap, this._testData, {Key key}) : super(key: key);

  @override
  _SolutionState createState() =>
      // ignore: no_logic_in_create_state
      _SolutionState(_answerMap, _bookmarkMap, _testData);
}

class _SolutionState extends State<Solution> {
  final Map _answerMap, _bookmarkMap;
  final List _testData;

  _SolutionState(this._answerMap, this._bookmarkMap, this._testData);

  int _index = 0;
  int _noOFQuestions;
  bool _isFirstQuestion = true;
  bool _isLastQuestion = false;
  bool reviewLater = false;
  String _FORMATTED_TEST_DURATION;
  Map map = Map();
  PageController _controller = PageController(viewportFraction: 1, keepPage: true);
  PageController _controllerList = PageController(viewportFraction: 0.15, keepPage: true);

  @override
  void initState() {
    print("123456");
    _noOFQuestions = _testData.length;
    _getData();
    super.initState();
  }

  void _getData() async {
    // print("123456");
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // map = jsonDecode(sp.getString("test1"));
    // print("------------------------");
    // print("123456");
    // print(map);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [headingRow(), questionRow(), _questionNoRow(), _buttonRow()],
      ),
    );
  }

  Widget headingRow() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1))]),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(Icons.timer),
          const SizedBox(
            width: 3,
          ),
          Text(
            _FORMATTED_TEST_DURATION,
            style: const TextStyle(
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
      padding: const EdgeInsets.all(0),
      child: Container(
        height: MediaQuery.of(context).size.height * 6 / 10,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: PageView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: _noOFQuestions,
          onPageChanged: (i) {
            HapticFeedback.selectionClick();
            _controllerList.animateToPage(i, curve: Curves.decelerate, duration: const Duration(milliseconds: 300));
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
            bool _correction = false;
            if (_answerMap.containsKey(_testData[i]['sno'])) {
              if (_answerMap[_testData[i]['sno']].toString() == _testData[i]['answer']) {
                _correction = true;
              } else {
                _correction = false;
              }
            }
            return Transform.scale(
              scale: i == _index ? 1 : 0.95,
              transformHitTests: true,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white54),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 1, spreadRadius: 1, offset: Offset(0, 1))]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Center(
                                child: Text(
                              (i + 1).toString(),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text(
                            "4",
                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
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
                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
//                          Checkbox(
//                            checkColor: Colors.white,
//                            onChanged: (value){
//                              setState(() {
//                                if(_bookmarkMap[_testData[i]['sno']]=="true"){
//                                  reviewLater=false;
////                                  _bookmarkMap.update(_testData[i]['sno'], (value) => "false",ifAbsent: () => "false",);
//                                  _bookmarkMap.remove(_testData[i]['sno']);
//                                }else{
//                                  reviewLater=true;
//                                  _bookmarkMap.update(_testData[i]['sno'], (value) => "true",ifAbsent: () => "true",);
//                                }
//                                //
//                              });
//                            },
//                            value: _bookmarkMap[_testData[i]['sno']]=="true"?true:false,
//                          ),
//                          Text("Review Later",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600),),
                          Text(
                            _correction ? "Your answer was correct" : "Wrong Answer",
                            style: TextStyle(color: _correction ? Colors.green : Colors.red),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 3 / 10,
                        child: SingleChildScrollView(
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.memory(base64.decode(_testData[i]['encodedSolution'] == null ? "" : _testData[i]['encodedSolution']), gaplessPlayback: true),
                              )
                            ],
                          ),
                        ),
                      ),
//                      SizedBox(height: 20,),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Correct Answer : ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
                                ),
                                Text((int.parse(_testData[i]['answer'])).toString(), style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Your Answer : ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
                                Text(_answerMap.containsKey(_testData[i]['sno']) ? (_answerMap[_testData[i]['sno']]).toString() : " Unanswered")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Time taken : ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
                                Text(map.containsKey(_testData[i]['sno'].toString()) ? (map[_testData[i]['sno'].toString()]).toString() : " 0")
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 10,
                        child: ListView.builder(
                          itemCount: int.parse(_testData[i]['noOfOptions']),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, j) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    //_answerMap.update(_testData[i]['sno'], (value) => j,ifAbsent: () => j,);
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 2 / 10,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(border: Border.all(color: _answerMap[_testData[i]['sno']] != j + 1 ? Colors.white : Colors.green)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  CircleAvatar(
                                                    child: Text(
                                                      (j + 1).toString(),
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    radius: 15,
                                                    backgroundColor: _answerMap[_testData[i]['sno']] != j + 1 ? Colors.grey : Colors.green,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(child: Text((j + 1).toString()))
                                                ],
                                              ),
                                            ),
//                                            Divider(height: 1,color: _answerMap[_testData[i]['sno']]!=j+1?Colors.grey:Colors.green,thickness: 3,)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            CustomButton(
                              buttonText: 'Hint',
                              brdRds: 10,
                              onPressed: () {
                                _solutionAlertBox(i);
                              },
                              verpad: EdgeInsets.symmetric(vertical: 10),
                            )
                          ],
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

  Widget _buttonRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6 / 10,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
//                _controller.animateToPage(_index-1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
//                _controllerList.animateToPage(_index-1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
              },
              child: Container(
                decoration: BoxDecoration(
//                    color: _isFirstQuestion?Colors.orange.withOpacity(0.6):Colors.deepPurpleAccent
                    color: Colors.orange),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
//                      Icon(Icons.arrow_back,color: Colors.white,),
                      Text(
                        "Silly",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.8),
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
//                _controller.animateToPage(_index+1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
//                _controllerList.animateToPage(_index+1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
              },
              child: Container(
                decoration: BoxDecoration(
//                    color: _isLastQuestion?Colors.orangeAccent.withOpacity(0.6):Colors.deepPurpleAccent
                    color: Colors.orange),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Conceptual", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
//                      Icon(Icons.arrow_forward,color: Colors.white,),
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

  Widget _questionNoRow() {
    return Container(
      padding: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.9 / 10,
      width: MediaQuery.of(context).size.width,
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
                _controller.animateToPage(i, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
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
    );
  }

  _solutionAlertBox(int i) {
    String ImageUrl = imageUrl + _testData[i]['solutionDirectory'] + "/" + _testData[i]['solutionFileName'];
    print(imageUrl);
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        FadeInImage(
                          placeholder: AssetImage("assets/lurnify.png"),
                          image: NetworkImage(ImageUrl),
                        )
                      ],
                    )),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
