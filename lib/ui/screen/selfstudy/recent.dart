import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/helper/helper.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/screen.dart';
import 'package:lurnify/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recent extends StatefulWidget {
  final String pageKey;
  Recent(this.pageKey);
  @override
  _RecentState createState() => _RecentState(pageKey);
}

class _RecentState extends State<Recent> {
  String pageKey;
  _RecentState(this.pageKey);
  List<Map<String,dynamic>> recentData = [];
  List nextData = [];
  bool lastTopicResult = false;
  var data;
  get fullWidth => Responsive.getPercent(100, ResponsiveSize.WIDTH, context);
  Future _getRecentData() async {
    try {
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +
      //     "getRecentStudy?registrationSno=" +
      //     sp.getString("studentSno");
      // print(url);
      // http.Response response = await http.get(
      //   Uri.encodeFull(url),
      // );
      // var resbody = jsonDecode(response.body);
      // recentData = resbody;
      RecentStudyRepo recentStudyRepo = new RecentStudyRepo();
      recentData = await recentStudyRepo.getRecentStudy();
      print(recentData);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    data = _getRecentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _title;
    String _fabText;
    if (pageKey == "1") {
      _title = 'Self Study Section';
      _fabText = 'Start Study';
    } else if (pageKey == "2") {
      _title = 'Sync your Study';
      _fabText = 'Sync Study';
    } else if (pageKey == "3") {
      _title = 'Goals';
      _fabText = 'Sync Study';
    }
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      // SizedBox(
                      //   height: 8,
                      // ),
                      // SizedBox(
                      //   width: Responsive.getPercent(
                      //       80, ResponsiveSize.WIDTH, context),
                      //   child: CustomButton(
                      //     brdRds: 10,
                      //     buttonText: 'Select New Study Topic',
                      //     onPressed: () {
                      //       Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => ContentSelection(pageKey),
                      //         ),
                      //       );
                      //     },
                      //     verpad: EdgeInsets.symmetric(vertical: 10),
                      //   ),
                      // ),
                      SizedBox(
                        height: 8,
                      ),
                      sHistory(context, _width),
                      SizedBox(
                        height: 8,
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
        buttonText: _fabText,
        verpad: EdgeInsets.symmetric(vertical: 5),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ContentSelect(pageKey),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   foregroundColor: Colors.white,
      //   onPressed: () => Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ContentSelect(pageKey),
      //     ),
      //   ),
      //   icon: Icon(Icons.arrow_forward_ios_rounded),
      //   label: Text(_fabText),
      // ),
    );
  }

  Widget sHistory(context, _width) {
    return recentData == null
        ? Container()
        : Container(
            padding: EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: recentData.length,
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return AspectRatio(
                    aspectRatio: 4 / 2,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.cyan[200].withOpacity(0.1),
                                  Colors.purple[200].withOpacity(0.1)
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                tileColor: firstColor,
                                // leading:
                                //     recentData[i]['studyType'] != "Complete"
                                //         ? Icon(
                                //             Icons.pending_actions,
                                //             color: Colors.red,
                                //           )
                                //         : Icon(
                                //             Icons.check_circle_outline_rounded,
                                //             color: Colors.green,
                                //           ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        recentData[i]['subjectName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Flexible(
                                    //   flex: 2,
                                    //   child: Text(
                                    //     "Unit : " + recentData[i]['unitName'],
                                    //     style: TextStyle(color: Colors.white),
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    // ),
                                    Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            recentData[i]['studyType'] !=
                                                    "Complete"
                                                ? Icon(
                                                    Icons.pending_actions,
                                                    color: Colors.red,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    color: Colors.green,
                                                  ),
                                          ],
                                        )),
                                    // Container(
                                    //   padding: EdgeInsets.all(5),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     color: Colors.white,
                                    //   ),
                                    //   child: Text(
                                    //     recentData[i]['studyType'],
                                    //     style: TextStyle(color: Colors.black),
                                    //   ),
                                    // )
                                  ],
                                ),
                                // subtitle: Text(
                                //   "Unit : " + recentData[i]['unitName'],
                                //   style: TextStyle(color: Colors.white),
                                // ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Chapter : " + recentData[i]['chapterName'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        recentData[i]['topicName'] + ":  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Expanded(
                                        child: Text(
                                          recentData[i]['subTopic'] == null
                                              ? ""
                                              : recentData[i]['subTopic'],
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              recentData[i]['studyType'] != "Complete"
                                  ? TextButton(
                                      onPressed: () {
                                        String subjectSno = recentData[i]
                                                ['subjectSno']
                                            .toString();
                                        String unitSno =
                                            recentData[i]['unitSno'].toString();
                                        String chapterSno = recentData[i]
                                                ['chapterSno']
                                            .toString();
                                        String topicSno = recentData[i]
                                                ['topicSno']
                                            .toString();
                                        String subTopic = recentData[i]
                                                ['subTopic']
                                            .toString();
                                        String duration = recentData[i]
                                                ['duration']
                                            .toString();
                                        print("---------------1" + duration);
                                        _goToNextScreen(
                                            subjectSno,
                                            unitSno,
                                            chapterSno,
                                            topicSno,
                                            subTopic,
                                            duration);
                                      },
                                      child: const Text('Start Study'),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        String subjectSno = recentData[i]
                                                ['subjectSno']
                                            .toString();
                                        String subjectName = recentData[i]
                                                ['subjectName']
                                            .toString();
                                        String unitSno =
                                            recentData[i]['unitSno'].toString();
                                        String unitName = recentData[i]
                                                ['unitName']
                                            .toString();
                                        String chapterSno = recentData[i]
                                                ['chapterSno']
                                            .toString();
                                        String chapterName = recentData[i]
                                                ['chapterName']
                                            .toString();
                                        String topicSno = recentData[i]
                                                ['topicSno']
                                            .toString();
                                        _getNextTopic(
                                            subjectSno,
                                            subjectName,
                                            unitSno,
                                            unitName,
                                            chapterSno,
                                            chapterName,
                                            topicSno);
                                      },
                                      child: const Text(
                                        "Study Next Topic",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                              Container(
                                width: fullWidth,
                                padding: EdgeInsets.all(5),
                                color: Colors.grey[50],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Last Studied : ",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      recentData[i]['enteredDate'],
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  // Widget sHistory(context, _width) {
  //   return recentData == null
  //       ? Container()
  //       : Container(
  //           padding: EdgeInsets.all(5),
  //           child: ListView.builder(
  //             itemCount: recentData.length,
  //             primary: false,
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             itemBuilder: (context, i) {
  //               return Card(
  //                 elevation: 10,
  //                 clipBehavior: Clip.antiAlias,
  //                 child: Column(
  //                   children: [
  //                     ListTile(
  //                       tileColor: firstColor,
  //                       leading: recentData[i]['studyType'] != "Complete"
  //                           ? Icon(
  //                               Icons.pending_actions,
  //                               color: Colors.red,
  //                             )
  //                           : Icon(
  //                               Icons.check_circle_outline_rounded,
  //                               color: Colors.green,
  //                             ),
  //                       title: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             recentData[i]['subjectName'],
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           Container(
  //                             padding: EdgeInsets.all(5),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(5),
  //                               color: Colors.white,
  //                             ),
  //                             child: Text(
  //                               recentData[i]['studyType'],
  //                               style: TextStyle(color: Colors.black),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                       subtitle: Text(
  //                         "Unit : " + recentData[i]['unitName'],
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: Text(
  //                         "Chapter : " + recentData[i]['chapterName'],
  //                         style: TextStyle(fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: Row(
  //                         children: [
  //                           Text(
  //                             recentData[i]['topicName'] + ":  ",
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.bold, fontSize: 14),
  //                           ),
  //                           Expanded(
  //                             child: Text(
  //                               recentData[i]['subTopic'] == null
  //                                   ? ""
  //                                   : recentData[i]['subTopic'],
  //                               style: TextStyle(fontSize: 13),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     ButtonBar(
  //                       alignment: MainAxisAlignment.end,
  //                       children: [
  //                         recentData[i]['studyType'] != "Complete"
  //                             ? TextButton(
  //                                 onPressed: () {
  //                                   String subjectSno =
  //                                       recentData[i]['subjectSno'].toString();
  //                                   String unitSno =
  //                                       recentData[i]['unitSno'].toString();
  //                                   String chapterSno =
  //                                       recentData[i]['chapterSno'].toString();
  //                                   String topicSno =
  //                                       recentData[i]['topicSno'].toString();
  //                                   String subTopic =
  //                                       recentData[i]['subTopic'].toString();
  //                                   String duration =
  //                                       recentData[i]['duration'].toString();
  //                                   print("---------------1" + duration);
  //                                   _goToNextScreen(
  //                                       subjectSno,
  //                                       unitSno,
  //                                       chapterSno,
  //                                       topicSno,
  //                                       subTopic,
  //                                       duration);
  //                                 },
  //                                 child: const Text('Start Study'),
  //                               )
  //                             : TextButton(
  //                                 onPressed: () {
  //                                   String subjectSno =
  //                                       recentData[i]['subjectSno'].toString();
  //                                   String subjectName =
  //                                       recentData[i]['subjectName'].toString();
  //                                   String unitSno =
  //                                       recentData[i]['unitSno'].toString();
  //                                   String unitName =
  //                                       recentData[i]['unitName'].toString();
  //                                   String chapterSno =
  //                                       recentData[i]['chapterSno'].toString();
  //                                   String chapterName =
  //                                       recentData[i]['chapterName'].toString();
  //                                   String topicSno =
  //                                       recentData[i]['topicSno'].toString();
  //                                   _getNextTopic(
  //                                       subjectSno,
  //                                       subjectName,
  //                                       unitSno,
  //                                       unitName,
  //                                       chapterSno,
  //                                       chapterName,
  //                                       topicSno);
  //                                 },
  //                                 child: const Text(
  //                                   "Study Next Topic",
  //                                   style:
  //                                       TextStyle(fontWeight: FontWeight.w600),
  //                                 ),
  //                               ),
  //                       ],
  //                     ),
  //                     Container(
  //                       width: fullWidth,
  //                       padding: EdgeInsets.all(5),
  //                       color: Colors.grey[50],
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             "Last Studied : ",
  //                             style: TextStyle(
  //                                 color: Colors.black54,
  //                                 fontWeight: FontWeight.w800,
  //                                 fontSize: 12),
  //                           ),
  //                           Text(
  //                             recentData[i]['enteredDate'].substring(0, 10),
  //                             style: TextStyle(
  //                                 color: Colors.black54,
  //                                 fontWeight: FontWeight.w800,
  //                                 fontSize: 12),
  //                           ),
  //                           Text(
  //                             recentData[i]['enteredDate'].substring(11, 19),
  //                             style: TextStyle(
  //                                 color: Colors.black54,
  //                                 fontWeight: FontWeight.w800,
  //                                 fontSize: 12),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  // }

  _goToNextScreen(
      subjectSno, unitSno, chapterSno, topicSno, subTopic, duration) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String course = sp.getString("courseSno");
    print("---------------2" + duration);
    if (pageKey == "1") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StartTimer(course, subjectSno, unitSno,
                  chapterSno, topicSno, subTopic, duration)));
    } else if (pageKey == "2") {
      print("---------------3" + duration);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SyncYourTime(course, subjectSno, unitSno,
                  chapterSno, topicSno, duration)));
    }
  }

  Future _getNextTopic(subjectSno, subjectName, unitSno, unitName, chapterSno,
      chapterName, topicSno) async {
    try {
      // var url = baseUrl +
      //     "getNextTopic?chapterSno=" +
      //     chapterSno +
      //     "&topicSno=" +
      //     topicSno +
      //     "";
      // print(url);
      // http.Response response = await http.get(
      //   Uri.encodeFull(url),
      // );
      // print(url);
      // var resbody = jsonDecode(response.body);
      // nextData = resbody;
      DBHelper dbHelper = new DBHelper();
      print("111111-------------------" + topicSno);
      nextData = await dbHelper.getNextTopic(chapterSno, topicSno);
      print(nextData);
      if (nextData.isEmpty) {
        lastTopicResult = true;
        print(lastTopicResult);
        noTopicAlertBox();
      } else {
        lastTopicResult = false;
        print(lastTopicResult);
        topicAlertBox(subjectSno, subjectName, unitSno, unitName, chapterSno,
            chapterName, nextData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future topicAlertBox(subjectSno, subjectName, unitSno, unitName, chapterSno,
      chapterName, nextData) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.white70,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "'" +
                                          nextData[0]['topicName'] +
                                          "'" +
                                          " is Your Next Topic. Do you want to study?",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16),
                                    )),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Subject Name : " + subjectName,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Unit Name : " + unitName,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Subject Name : " + subjectName,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text(
                                    "Topic Name : " + nextData[0]['topicName'],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  "SubTopic Name : " + nextData[0]['subTopic'],
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text(
                                "START",
                                style: TextStyle(color: Colors.black87),
                              ),
                              onPressed: () {
                                nextTopicStart(
                                    subjectSno,
                                    unitSno,
                                    chapterSno,
                                    nextData[0]['sno'].toString(),
                                    nextData[0]['subTopic'],
                                    nextData[0]['duration']);
                              },
                            ),
                          ],
                        ),
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
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  Future noTopicAlertBox() {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.white70,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Congratulations! You have completed all the topics of this chapter. Please Select another chapter.",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16),
                                    )),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
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
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  nextTopicStart(
      subjectSno, unitSno, chapterSno, topicSno, subTopic, duration) {
    Navigator.of(context).pop();
    if (pageKey == "1") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StartTimer("1", subjectSno, unitSno,
                  chapterSno, topicSno, subTopic, duration)));
    } else if (pageKey == "2") {
      print("---------------" + duration);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SyncYourTime(
                  "1", subjectSno, unitSno, chapterSno, topicSno, duration)));
    }
  }
}
