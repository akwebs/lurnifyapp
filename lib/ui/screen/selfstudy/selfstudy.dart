import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/screen/selfstudy/recent.dart';
import 'package:lurnify/ui/screen/selfstudysection/GoalsLearnMore.dart';
import 'package:lurnify/ui/screen/selfstudysection/SyncStudyTimeLearnMore.dart';
import 'package:lurnify/ui/screen/selfstudysection/startSelfStudyLearnMore.dart';
import 'package:lurnify/ui/screen/selfstudysection/statisticksLearnMore.dart';
import 'package:lurnify/widgets/componants/custom-button.dart';
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
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      selectPace(context),
                      contentCards(context)
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
    );
  }

  Widget selectPace(context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black26,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              CustomButton(
                brdRds: 10,
                verpad: EdgeInsets.symmetric(vertical: 10),
                buttonText: 'Select the Pace of Self-Study Program',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(select_pace);
                },
              ),
              Divider(),
              Text(
                "Course Completion on : $_courseCompletetioDate",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
//                  color: secondColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "12 Days",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                          Text("Behind",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 12))
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 70,
                      color: Colors.black.withOpacity(0.2),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
//                        Text("",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 12)),
                          Text("Add 20 mins",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 18)),
                          Text("Daily To Comp. Timely",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 12)),
//                        Text("in Daily Study",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 12))
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 70,
                      color: Colors.black.withOpacity(0.2),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text("12%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 18)),
                          Text("Syl. Complete",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contentCards(context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _card("Start Self Study", Recent("1"), StartSelfStudyLearnMore(),
              "Are you ready to", "START?"),
          SizedBox(
            height: 10,
          ),
          _card("Sync Study Time", Recent("2"), SyncStudyTimeLearnMore(),
              "Missed Out!", "Study Time Punching?"),
          SizedBox(
            height: 10,
          ),
          _card("Statistics", null, StatisticsLearnMore(),
              "Track your statistics", "HERE!!!"),
          SizedBox(
            height: 10,
          ),
          _card("Goals", null, GolasLearnMore(), "See your achievements",
              "HERE!!!"),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _card(String text, Widget mainWidget, Widget learnMoreWidget,
      String addMessage1, String addMessage2) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black26,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              addMessage1,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(addMessage2, style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 15,
            ),
            Container(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/logo_light.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: Responsive.getPercent(80, ResponsiveSize.WIDTH, context),
              child: CustomButton(
                brdRds: 10,
                buttonText: text,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => mainWidget,
                  ));
                },
                verpad: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GolasLearnMore(),
                      ));
                },
                child: Text(
                  'Learn More',
                  style: TextStyle(color: firstColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
