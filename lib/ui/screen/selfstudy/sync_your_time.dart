import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../helper/study_repo.dart';
import '../../constant/constant.dart';
import 'study_complete.dart';
import 'package:material_switch/material_switch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncYourTime extends StatefulWidget {
  final course, subject, unit, chapter, topic, duration;

  SyncYourTime(this.course, this.subject, this.unit, this.chapter, this.topic, this.duration);

  @override
  _SyncYourTime createState() => _SyncYourTime(course, subject, unit, chapter, topic, duration);
}

class _SyncYourTime extends State<SyncYourTime> {
  String course, subject, unit, chapter, topic, duration;

  _SyncYourTime(this.course, this.subject, this.unit, this.chapter, this.topic, this.duration);

  // ignore: unused_field
  double _height;
  // ignore: unused_field
  double _width;
  double startHr = 0;
  double startMin = 0;
  double endHr = 0;
  double endMin = 0;
  List<String> startDays = ["Yesterday", "Today"];
  String selectedStartDays = "Today";
  List<String> endDays = ["Yesterday", "Today"];
  String selectedEndDays = "Today";

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync Your Study'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                questionAlertBox(context);
              })
        ],
        elevation: 5,
      ),
      body: Material(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              firstRow(),
              SizedBox(
                height: 10,
              ),
              startTimeCard(),
              endTimeCard(),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        onPressed: () {
          _endSession();
        },
        label: Row(
          children: [
            Text(
              'SYNC',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.sync_outlined,
              size: 20,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future questionAlertBox(context) {
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
                title: Text(
                  "Study Help",
                  textAlign: TextAlign.center,
                ),
                content: Container(
                    height: 300,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Here will some subtopics and data for study help",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
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
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget firstRow() {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              color: firstColor,
            ),
            child: Text(
              "Duration of Study Session",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.w800, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "2:30 hours",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          Text(
            "Studied in this purchased session",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget startTimeCard() {
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              color: firstColor,
            ),
            child: Text(
              "Self Study Starting Time",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I started self study session  '),
              Text(
                'at ' + startHr.round().toString() + ' Hr : ' + startMin.round().toString() + ' Min' + ' $selectedStartDays',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MaterialSwitch(
                    selectedOption: selectedStartDays,
                    options: startDays,
                    selectedBackgroundColor: Colors.deepPurple,
                    selectedTextColor: Colors.white,
                    onSelect: (String selectedOption) {
                      setState(() {
                        selectedStartDays = selectedOption;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Hr",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.green[100],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withAlpha(32),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.green,
                          inactiveTickMarkColor: Colors.green[100],
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.green,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          value: startHr,
                          min: 0,
                          max: 23,
                          divisions: 23,
                          label: startHr.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              startHr = value;
                              if (startHr != 23) {
                                endHr = startHr + 1;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Min",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.orange[700],
                              inactiveTrackColor: Colors.orange[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                              thumbColor: Colors.white,
                              overlayColor: Colors.orange.withAlpha(32),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.orange[700],
                              inactiveTickMarkColor: Colors.orange[100],
                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.orange,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              value: startMin,
                              min: 0,
                              max: 59,
                              divisions: 59,
                              label: startMin.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  startMin = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget endTimeCard() {
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              color: firstColor,
            ),
            child: Text(
              "Self Study End Time",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I started self study session  '),
              Text(
                'at ' + endHr.round().toString() + ' Hr : ' + endMin.round().toString() + ' Min' + ' $selectedEndDays',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MaterialSwitch(
                    selectedOption: selectedEndDays,
                    options: endDays,
                    selectedBackgroundColor: Colors.deepPurple,
                    selectedTextColor: Colors.white,
                    onSelect: (String selectedOption) {
                      setState(() {
                        selectedEndDays = selectedOption;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Hr",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.green[100],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withAlpha(32),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.green,
                          inactiveTickMarkColor: Colors.green[100],
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.green,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          value: endHr,
                          min: 0,
                          max: 23,
                          divisions: 23,
                          label: endHr.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              endHr = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Min",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.orange[700],
                              inactiveTrackColor: Colors.orange[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                              thumbColor: Colors.white,
                              overlayColor: Colors.orange.withAlpha(32),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.orange[700],
                              inactiveTickMarkColor: Colors.orange[100],
                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.orange,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              value: endMin,
                              min: 0,
                              max: 59,
                              divisions: 59,
                              label: endMin.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  endMin = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  // Widget endTimeCardX() {
  //   return Padding(
  //     padding: EdgeInsets.all(5),
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: Colors.blue,
  //           borderRadius: BorderRadius.circular(5),
  //           boxShadow: [
  //             BoxShadow(
  //                 color: Colors.grey.withOpacity(0.8),
  //                 spreadRadius: 2,
  //                 blurRadius: 2,
  //                 offset: Offset(0, 2))
  //           ]),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.only(top: 3, bottom: 3),
  //             width: MediaQuery.of(context).size.width,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(5), topRight: Radius.circular(5)),
  //               color: Colors.cyan,
  //             ),
  //             child: Text(
  //               "Self Study End Time",
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w800,
  //                   fontSize: 20),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.white, borderRadius: BorderRadius.circular(5)),
  //             padding: EdgeInsets.only(left: 15, right: 15),
  //             child: RichText(
  //               text: TextSpan(
  //                   style: new TextStyle(
  //                       fontSize: 13.0,
  //                       color: Colors.black54,
  //                       fontWeight: FontWeight.w500),
  //                   children: [
  //                     TextSpan(text: "I started self study session "),
  //                     TextSpan(
  //                         text: "at " +
  //                             endHr.round().toString() +
  //                             ":" +
  //                             endMin.round().toString() +
  //                             " $selectedEndDays",
  //                         style: TextStyle(
  //                             color: Colors.deepPurple,
  //                             fontWeight: FontWeight.w800,
  //                             fontSize: 13))
  //                   ]),
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Expanded(
  //                   child: MaterialSwitch(
  //                     selectedOption: selectedEndDays,
  //                     options: endDays,
  //                     selectedBackgroundColor: Colors.deepPurpleAccent,
  //                     selectedTextColor: Colors.white,
  //                     onSelect: (String selectedOption) {
  //                       setState(() {
  //                         selectedEndDays = selectedOption;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Container(
  //               padding: EdgeInsets.all(5),
  //               decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.blue[100]),
  //                   color: Colors.blueAccent,
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         Text(
  //                           "Hr",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w800),
  //                         ),
  //                         Container(
  //                           width: MediaQuery.of(context).size.width / 1.5,
  //                           child: SliderTheme(
  //                             data: SliderTheme.of(context).copyWith(
  //                               activeTrackColor: Colors.green[700],
  //                               inactiveTrackColor: Colors.green[100],
  //                               trackShape: RoundedRectSliderTrackShape(),
  //                               trackHeight: 4.0,
  //                               thumbShape: RoundSliderThumbShape(
  //                                   enabledThumbRadius: 12.0),
  //                               thumbColor: Colors.white,
  //                               overlayColor: Colors.green.withAlpha(32),
  //                               overlayShape: RoundSliderOverlayShape(
  //                                   overlayRadius: 28.0),
  //                               tickMarkShape: RoundSliderTickMarkShape(),
  //                               activeTickMarkColor: Colors.green[700],
  //                               inactiveTickMarkColor: Colors.green[100],
  //                               valueIndicatorShape:
  //                                   PaddleSliderValueIndicatorShape(),
  //                               valueIndicatorColor: Colors.green,
  //                               valueIndicatorTextStyle: TextStyle(
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                             child: Slider(
  //                               value: endHr,
  //                               min: 0,
  //                               max: 23,
  //                               divisions: 23,
  //                               label: endHr.round().toString(),
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   endHr = value;
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Container(
  //               padding: EdgeInsets.all(5),
  //               decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.blue[100]),
  //                   color: Colors.blueAccent,
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         Text(
  //                           "Min",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w800),
  //                         ),
  //                         Container(
  //                           width: MediaQuery.of(context).size.width / 1.5,
  //                           child: SliderTheme(
  //                             data: SliderTheme.of(context).copyWith(
  //                               activeTrackColor: Colors.orange[700],
  //                               inactiveTrackColor: Colors.orange[100],
  //                               trackShape: RoundedRectSliderTrackShape(),
  //                               trackHeight: 4.0,
  //                               thumbShape: RoundSliderThumbShape(
  //                                   enabledThumbRadius: 12.0),
  //                               thumbColor: Colors.white,
  //                               overlayColor: Colors.orange.withAlpha(32),
  //                               overlayShape: RoundSliderOverlayShape(
  //                                   overlayRadius: 28.0),
  //                               tickMarkShape: RoundSliderTickMarkShape(),
  //                               activeTickMarkColor: Colors.orange[700],
  //                               inactiveTickMarkColor: Colors.orange[100],
  //                               valueIndicatorShape:
  //                                   PaddleSliderValueIndicatorShape(),
  //                               valueIndicatorColor: Colors.orange,
  //                               valueIndicatorTextStyle: TextStyle(
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                             child: Slider(
  //                               value: endMin,
  //                               min: 0,
  //                               max: 59,
  //                               divisions: 59,
  //                               label: endMin.round().toString(),
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   endMin = value;
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _endSession() async {
    if (selectedStartDays == "Today" && selectedEndDays == "Yesterday") {
      print("error");
      toastMethod("Invalid Time");
    } else {
      String startDate = "";
      String endDate = "";
      int additionDay = 0;
      if (selectedStartDays == "Yesterday") {
        startDate = DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0];
      } else {
        startDate = DateTime.now().toString().split(" ")[0];
      }
      if (selectedEndDays == "Yesterday") {
        endDate = DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0];
      } else {
        endDate = DateTime.now().toString().split(" ")[0];
      }
      if (selectedStartDays == "Yesterday" && selectedEndDays == "Today") {
        additionDay = 24 * 60 * 60;
      }
      String startHour = "00", startMinute = "00", endHour = "00", endMinute = "00";
      if (startHr.round().toString().length < 2) {
        startHour = "0" + startHr.round().toString();
      } else {
        startHour = startHr.round().toString();
      }
      if (startMin.round().toString().length < 2) {
        startMinute = "0" + startMin.round().toString();
      } else {
        startMinute = startMin.round().toString();
      }
      if (endHr.round().toString().length < 2) {
        endHour = "0" + endHr.round().toString();
      } else {
        endHour = endHr.round().toString();
      }
      if (endMin.round().toString().length < 2) {
        endMinute = "0" + endMin.round().toString();
      } else {
        endMinute = endMin.round().toString();
      }
      String startingTime = startHour + ":" + startMinute + ":00";

      String endTime = endHour + ":" + endMinute + ":00";
      int startSeconds = Duration(hours: startHr.round(), minutes: startMin.round()).inSeconds;
      int endSeconds = Duration(hours: endHr.round(), minutes: endMin.round()).inSeconds + additionDay;
      int totalSeconds = endSeconds - startSeconds;
      if (totalSeconds < 1) {
        print("minus error");
        toastMethod("Invalid Time");
      } else {
        print("ok");
        int newHr = endHr.round() - startHr.round();
        int newMin = endMin.round() - startMin.round();
        String time = newHr.toString() + ":" + newMin.toString() + ":00";
        startDate = startDate + " " + startingTime;
        endDate = endDate + " " + endTime;
        SharedPreferences sp = await SharedPreferences.getInstance();
        // var url = baseUrl +
        //     "checkEndDateForManualEntry?date=" +
        //     startDate +
        //     "&registrationSno=" +
        //     sp.getString("studentSno");
        // print(url);
        // http.Response response = await http.get(
        //   Uri.encodeFull(url),
        // );
        // var resbody = jsonDecode(response.body);
        // print(resbody);
        // Map<String, dynamic> mapResult = resbody;
        StudyRepo studyRepo = new StudyRepo();
        List<Map<String, dynamic>> list = await studyRepo.checkEndDateForManualEntry();
        bool check = false;
        print(list);
        if (list.isEmpty) {
          check = true;
        } else {
          String endDate = "";
          for (var a in list) {
            endDate = a['endDate'];
          }
          DateTime sDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(startDate);
          DateTime eDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(endDate);
          print(sDate);
          print(eDate);
          if (eDate.isAfter(sDate)) {
            check = false;
          } else {
            check = true;
          }
        }
        print("111111111111111111111111111111111111");
        print(check);
        if (check) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudyComplete(time, totalSeconds.toString(), startDate, endDate, course, subject, unit, chapter, topic, duration),
              ));
        } else {
          toastMethod("Please Enter correct end date.");
        }
      }
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 18.0);
  }
}
