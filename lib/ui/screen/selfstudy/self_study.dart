import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/screen/screen.dart';
import 'package:lurnify/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfStudySection extends StatefulWidget {
  @override
  _SelfStudySectionState createState() => _SelfStudySectionState();
}

class _SelfStudySectionState extends State<SelfStudySection> {
  String _courseCompletetioDate = "";

  Future getCourseDate() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _courseCompletetioDate = sp.getString("courseCompletionDate");
    if (_courseCompletetioDate == null) {
      _courseCompletetioDate = "Date not Selected";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self Study Section"),
        centerTitle: true,
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.info),
          //   onPressed: () {
          //     _pace(context);
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Recent("2"),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCourseDate(),
        builder: (BuildContext context, AsyncSnapshot s) {
          if (s.connectionState == ConnectionState.done) {
            return Material(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      pace(context),
                      SizedBox(
                        height: 40,
                      ),
                      _motivationCards(context),
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: whiteColor,
        onPressed: () {
          _pace(context);
        },
        child: Icon(Icons.info),
      ),
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        icon: Icons.add,
        verpad: EdgeInsets.symmetric(vertical: 5),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Recent("1"),
          ));
        },
      ),
    );
  }

  Widget _motivationCards(context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(10),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/quotes.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pace(context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      child: Column(
        children: <Widget>[
          // CustomButton(
          //   brdRds: 10,
          //   verpad: EdgeInsets.symmetric(vertical: 10),
          //   buttonText: 'Select the Pace of Self-Study Program',
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pushNamed(select_pace);
          //   },
          // ),
          // Divider(),
          Text(
            "Course Completion on : $_courseCompletetioDate",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "12 Days" + " Behind",
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Add 20 mins" + "Daily To Comp. Timely",
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "12% " + "Syllabus completed",
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(selectPace);
                },
                child: Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget contentCards(context) {
  //   return Padding(
  //     padding: EdgeInsets.all(5),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         _card("Start Self Study", Recent("1"), StartSelfStudyLearnMore(),
  //             "Are you ready to", "START?"),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         _card("Sync Study Time", Recent("2"), SyncStudyTimeLearnMore(),
  //             "Missed Out!", "Study Time Punching?"),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         _card("Statistics", null, StatisticsLearnMore(),
  //             "Track your statistics", "HERE!!!"),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         _card("Goals", null, GolasLearnMore(), "See your achievements",
  //             "HERE!!!"),
  //         SizedBox(
  //           height: 10,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _card(String text, Widget mainWidget, Widget learnMoreWidget,
  //     String addMessage1, String addMessage2) {
  //   return Card(
  //     elevation: 0,
  //     shadowColor: Colors.black26,
  //     margin: EdgeInsets.symmetric(horizontal: 5),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Text(
  //             addMessage1,
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           Text(addMessage2, style: TextStyle(fontSize: 16)),
  //           SizedBox(
  //             height: 15,
  //           ),
  //           Container(
  //             child: CircleAvatar(
  //               radius: 50,
  //               backgroundImage: AssetImage('assets/images/logo_light.png'),
  //               backgroundColor: Colors.transparent,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 15,
  //           ),
  //           SizedBox(
  //             width: Responsive.getPercent(80, ResponsiveSize.WIDTH, context),
  //             child: CustomButton(
  //               brdRds: 10,
  //               buttonText: text,
  //               onPressed: () {
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => mainWidget,
  //                 ));
  //               },
  //               verpad: EdgeInsets.symmetric(vertical: 15),
  //             ),
  //           ),
  //           SizedBox(
  //             child: CupertinoButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => GolasLearnMore(),
  //                     ));
  //               },
  //               child: Text(
  //                 'Learn More',
  //                 style: TextStyle(color: firstColor),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  _pace(context) {
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
                title: Column(
                  children: [
                    Text(
                      'Course Completion on',
                      style: TextStyle(color: firstColor),
                    ),
                    Text(
                      '$_courseCompletetioDate',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                content: Container(
                    height: 200,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '12 Days Behind',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'Add 20 mins daily to Complete Timely',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '12% Syllabus complete',
                              ),
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
}
