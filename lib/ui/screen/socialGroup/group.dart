import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/social_group_model.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/userProfile/user-profile.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class GroupBoard extends StatefulWidget {
  const GroupBoard({Key key}) : super(key: key);

  @override
  _GroupBoardState createState() => _GroupBoardState();
}

class _GroupBoardState extends State<GroupBoard> {
  List<SocialGroupModel> leadersList = [];
  List<SocialGroupModel> followersList = [];
  int _currentFollowerField = 1;
  int _currentLeaderField = 1;
  var _data;

  _getData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl + 'getLeadersAndFollowers?register=${sp.getString('studentSno')}';
    http.Response response = await http.post(Uri.encodeFull(url));
    if (response.statusCode > 200) {
      var resBody = jsonDecode(response.body);
      List leaderList = resBody['leader'];
      List followerList = resBody['follower'];
      int _check = 0;
      var _lastMonday = DateTime.now();
      var _lastSunday = DateTime.now();

      for (int i = 0; i < 15; i++) {
        if (_lastMonday.weekday == 1) {
          _check++;
        }
        if (_check == 2) {
          break;
        }
        _lastMonday = _lastMonday.subtract(Duration(days: 1));
      }

      for (int i = 0; i < 15; i++) {
        if (_lastSunday.weekday == 1) {
          _check++;
        }
        if (_check == 2) {
          break;
        }
        _lastSunday = _lastSunday.subtract(Duration(days: 1));
      }

      //Getting self data
      SharedPreferences sp = await SharedPreferences.getInstance();
      SocialGroupModel socialGroupModel = SocialGroupModel();
      socialGroupModel.sno = sp.getString('studentSno');
      socialGroupModel.name = "Need to update";
      socialGroupModel.isUser = true;

      DBHelper dbHelper = DBHelper();
      Database database = await dbHelper.database;
      database.transaction((txn) async {
        List<Map<String, dynamic>> list = await txn.rawQuery("select ((correctQuestion/totalQuestion)*100) as testPercent"
            "  from topic_test_result "
            "where enteredDate>='$_lastMonday 00:00:00.0' "
            "and enteredDate<='$_lastSunday 00:00:00.0'");
        for (var a in list) {
          socialGroupModel.testPercent = a['testPercent'];
        }

        List<Map<String, dynamic>> list2 = await txn.rawQuery("select sum(credit) as totalDimes from dimes "
            "where enteredDate>='$_lastMonday 00:00:00.0' "
            "and enteredDate<='$_lastSunday 00:00:00.0'");
        for (var a in list2) {
          socialGroupModel.totalDimes = a['totalDimes'];
        }
        List<Map<String, dynamic>> list3 = await txn.rawQuery("select sum(totalSeconds)/3600 as totalStudyHour from study "
            "where date>='$_lastMonday' "
            "and date<='$_lastSunday'");
        for (var a in list3) {
          socialGroupModel.totalStudyHour = a['totalStudyHour'];
        }

        leadersList.add(socialGroupModel);
        followersList.add(socialGroupModel);

        return null;
      });

      for (var a in leaderList) {
        int totalStudySecond = 0;
        int totalDimes = 0;
        double testPercent = 0;
        int totalCorrectQuestion = 0;
        int totalQuestion = 0;
        await FirebaseFirestore.instance
            .collection('study')
            .where('date', isGreaterThanOrEqualTo: _lastMonday.toString().split(" ")[0])
            .where('date', isLessThanOrEqualTo: _lastSunday.toString().split(" ")[0])
            .where('register', isEqualTo: a['usedBy']['sno'])
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalStudySecond = totalStudySecond + int.tryParse(element.get('totalSecond'));
          });
        });

        await FirebaseFirestore.instance
            .collection('dimes')
            .where('registerSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: _lastMonday.toString().split(" ")[0] + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: _lastSunday.toString().split(" ")[0] + ' 00:00:00.0')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalDimes = totalDimes + int.tryParse(element.get('credit'));
          });
        });

        await FirebaseFirestore.instance
            .collection('topicTestResult')
            .where('regSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: _lastMonday.toString().split(" ")[0] + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: _lastSunday.toString().split(" ")[0] + ' 00:00:00.0')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            int correctQuestion = int.tryParse(element.get('correctQuestion'));
            int tQuestion = int.tryParse(element.get('totalQuestion'));
            totalCorrectQuestion = totalCorrectQuestion + correctQuestion;
            totalQuestion = totalQuestion + tQuestion;
          });
        });

        testPercent = (totalCorrectQuestion / totalQuestion) * 100;

        SocialGroupModel socialGroupModel = SocialGroupModel();
        socialGroupModel.sno = a['usedBy']['sno'].toString();
        socialGroupModel.name = a['usedBy']['name'];
        socialGroupModel.testPercent = testPercent;
        socialGroupModel.totalDimes = totalDimes;
        socialGroupModel.totalStudyHour = (((totalStudySecond / 3600) * 100).ceilToDouble() / 100);
        socialGroupModel.isUser = false;

        leadersList.add(socialGroupModel);
      }

      leadersList.sort((a, b) => a.totalStudyHour.compareTo(b.totalStudyHour));

      for (var a in followerList) {
        int totalStudySecond = 0;
        int totalDimes = 0;
        double testPercent = 0;
        int totalCorrectQuestion = 0;
        int totalQuestion = 0;
        await FirebaseFirestore.instance
            .collection('study')
            .where('date', isGreaterThanOrEqualTo: _lastMonday.toString().split(" ")[0])
            .where('date', isLessThanOrEqualTo: _lastSunday.toString().split(" ")[0])
            .where('register', isEqualTo: a['usedBy']['sno'])
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalStudySecond = totalStudySecond + int.tryParse(element.get('totalSecond'));
          });
        });

        await FirebaseFirestore.instance
            .collection('dimes')
            .where('registerSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: _lastMonday.toString().split(" ")[0] + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: _lastSunday.toString().split(" ")[0] + ' 00:00:00.0')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalDimes = totalDimes + int.tryParse(element.get('credit'));
          });
        });

        await FirebaseFirestore.instance
            .collection('topicTestResult')
            .where('regSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: _lastMonday.toString().split(" ")[0] + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: _lastSunday.toString().split(" ")[0] + ' 00:00:00.0')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            int correctQuestion = int.tryParse(element.get('correctQuestion'));
            int tQuestion = int.tryParse(element.get('totalQuestion'));
            totalCorrectQuestion = totalCorrectQuestion + correctQuestion;
            totalQuestion = totalQuestion + tQuestion;
          });
        });

        testPercent = (totalCorrectQuestion / totalQuestion) * 100;

        SocialGroupModel socialGroupModel = SocialGroupModel();
        socialGroupModel.sno = a['usedBy']['sno'].toString();
        socialGroupModel.name = a['usedBy']['name'];
        socialGroupModel.testPercent = testPercent;
        socialGroupModel.totalDimes = totalDimes;
        socialGroupModel.totalStudyHour = (((totalStudySecond / 3600) * 100).ceilToDouble() / 100);
        socialGroupModel.isUser = false;

        followersList.add(socialGroupModel);
      }

      followersList.sort((a, b) => a.totalStudyHour.compareTo(b.totalStudyHour));
    }
  }

  @override
  void initState() {
    _data = _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double topHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(children: [
                  SizedBox(
                    height: topHeight * 3.8 / 10,
                    width: width,
                    child: Image.asset(
                      'assets/trophy.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ]),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.blue),
                      child: AppBar(
                        brightness: Brightness.dark,
                        iconTheme: IconThemeData(color: whiteColor),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        title: Text(
                          'Leaders Group',
                          style: TextStyle(color: whiteColor),
                        ),
                        centerTitle: true,
                        actions: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserProfile(),
                              ));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, right: 8),
                              child: Container(
                                child: CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/anshul.png'),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: NewappColors.neumorpShadow,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.deepPurple,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: topHeight * 2 / 10),
                    height: topHeight,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'You are the leader',
                                    style: TextStyle(shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ], fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    child: Text(
                                      'For Completing the challenge you took 1st place. And get a 20% discount on Subcription.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.hardEdge,
                              child: Material(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text('Study Hours'),
                                              Icon(
                                                Icons.swap_vertical_circle_sharp,
                                                color: Colors.blue,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Test Score',
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                              Icon(
                                                Icons.swap_vertical_circle_sharp,
                                                color: Colors.blue,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text('Coins Earned'),
                                              Icon(
                                                Icons.swap_vertical_circle_sharp,
                                                color: Colors.blue,
                                                size: 16,
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
                            Expanded(
                              child: ListView.builder(
                                  itemCount: 20,
                                  itemBuilder: (BuildContext context, int i) {
                                    bool _isActive = false;
                                    bool _isOpened = true;
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: i == 0 ? Border.all(width: 1, color: Colors.blue[400]) : Border.all(width: 1, color: Colors.transparent),
                                      ),
                                      child: Stack(
                                        children: [
                                          Card(
                                            clipBehavior: Clip.hardEdge,
                                            margin: EdgeInsets.all(0),
                                            child: Container(
                                              color: Colors.blue.withOpacity(0.2),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Stack(
                                                        alignment: Alignment.bottomRight,
                                                        children: [
                                                          Container(
                                                            child: CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage: AssetImage('assets/images/anshul.png'),
                                                            ),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.deepPurple,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                          i == 0
                                                              ? Align(
                                                                  child: SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: Image.asset('assets/awesome-crown.png'),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Anil Kumar Jangid',
                                                                    maxLines: 1,
                                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    '#' + (i + 1).toString(),
                                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    i <= 4 ? (8 - i).toString() + '.00 hours' : (4).toString() + '.00 hours',
                                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    (100 - (i)).toString() + ' %',
                                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    (8000 - (i * 100)).toString() + ' Coins',
                                                                    style: TextStyle(fontWeight: FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              margin: EdgeInsets.only(top: 5, left: 5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _isActive
                                                    ? Colors.green
                                                    : _isOpened
                                                        ? Colors.orange
                                                        : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
