import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/social_group_model.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/socialGroup/group.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SocialGroup extends StatefulWidget {
  const SocialGroup({Key key}) : super(key: key);

  @override
  _SocialGroupState createState() => _SocialGroupState();
}

class _SocialGroupState extends State<SocialGroup> {
  // ignore: unused_field
  static List buttonText = [
    'Study Hours',
    'Coins Earned',
    'Test Score',
  ];
  // ignore: unused_field
  List<bool> _isSelected = List.generate(3, (i) => false);
  // ignore: unused_field
  String _selectedDateRange = "90 Days";
  // ignore: unused_field
  int _selectedSubjectIndex = 0;
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
      String yesterdayDate = DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0];
      String yesterdayEndDate = DateTime.now().toString().split(" ")[0];

      //Getting self data
      SharedPreferences sp = await SharedPreferences.getInstance();
      SocialGroupModel socialGroupModel = new SocialGroupModel();
      socialGroupModel.sno = sp.getString('studentSno');
      socialGroupModel.name = "Need to update";
      socialGroupModel.isUser = true;

      DBHelper dbHelper = new DBHelper();
      Database database = await dbHelper.database;
      database.transaction((txn) async {
        List<Map<String, dynamic>> list = await txn.rawQuery("select ((correctQuestion/totalQuestion)*100) as testPercent"
            "  from topic_test_result "
            "where enteredDate>='$yesterdayDate 00:00:00.0' "
            "and enteredDate<='$yesterdayEndDate 00:00:00.0'");
        for (var a in list) {
          socialGroupModel.testPercent = a['testPercent'];
        }

        List<Map<String, dynamic>> list2 = await txn.rawQuery("select sum(credit) as totalDimes from dimes "
            "where enteredDate>='$yesterdayDate 00:00:00.0' "
            "and enteredDate<='$yesterdayEndDate 00:00:00.0'");
        for (var a in list2) {
          socialGroupModel.totalDimes = a['totalDimes'];
        }
        List<Map<String, dynamic>> list3 = await txn.rawQuery("select sum(totalSeconds)/3600 as totalStudyHour from study where date='$yesterdayDate'");
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
        await FirebaseFirestore.instance.collection('study').where('date', isEqualTo: yesterdayDate).where('register', isEqualTo: a['usedBy']['sno']).get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalStudySecond = totalStudySecond + int.tryParse(element.get('totalSecond'));
          });
        });

        await FirebaseFirestore.instance
            .collection('dimes')
            .where('registerSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: yesterdayDate + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: yesterdayEndDate + ' 00:00:00.0')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalDimes = totalDimes + int.tryParse(element.get('credit'));
          });
        });

        await FirebaseFirestore.instance
            .collection('topicTestResult')
            .where('regSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: yesterdayDate + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: yesterdayEndDate + ' 00:00:00.0')
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
        bool _isLive = false;

        await FirebaseFirestore.instance
            .collection('lastOnline')
            .where('register', isEqualTo: a['usedBy']['sno'].toString())
            .orderBy('lastLoginTime', descending: true)
            .limit(1)
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            int lastLoginTime = element.get('lastLoginTime');
            if (DateTime.now().millisecondsSinceEpoch > lastLoginTime) {
              _isLive = true;
            }
          });
        });

        SocialGroupModel socialGroupModel = new SocialGroupModel();
        socialGroupModel.sno = a['usedBy']['sno'].toString();
        socialGroupModel.name = a['usedBy']['name'];
        socialGroupModel.testPercent = testPercent;
        socialGroupModel.totalDimes = totalDimes;
        socialGroupModel.totalStudyHour = (((totalStudySecond / 3600) * 100).ceilToDouble() / 100);
        socialGroupModel.isUser = false;
        socialGroupModel.isLive = _isLive;
        leadersList.add(socialGroupModel);
      }

      leadersList.sort((a, b) => a.totalStudyHour.compareTo(b.totalStudyHour));

      for (var a in followerList) {
        String yesterdayDate = DateTime.now().subtract(Duration(days: 1)).toString().split(" ")[0];
        int totalStudySecond = 0;
        int totalDimes = 0;
        double testPercent = 0;
        int totalCorrectQuestion = 0;
        int totalQuestion = 0;
        await FirebaseFirestore.instance.collection('study').where('date', isEqualTo: yesterdayDate).where('register', isEqualTo: a['usedBy']['sno']).get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalStudySecond = totalStudySecond + int.tryParse(element.get('totalSecond'));
          });
        });

        await FirebaseFirestore.instance
            .collection('dimes')
            .where('registerSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: yesterdayDate + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: yesterdayEndDate + ' 00:00:00.0')
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            totalDimes = totalDimes + int.tryParse(element.get('credit'));
          });
        });

        await FirebaseFirestore.instance
            .collection('topicTestResult')
            .where('regSno', isEqualTo: a['usedBy']['sno'])
            .where('enteredDate', isGreaterThanOrEqualTo: yesterdayDate + ' 00:00:00.0')
            .where('enteredDate', isLessThanOrEqualTo: yesterdayEndDate + ' 00:00:00.0')
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

        bool _isLive = false;
        await FirebaseFirestore.instance
            .collection('lastOnline')
            .where('register', isEqualTo: a['usedBy']['sno'].toString())
            .orderBy('lastLoginTime', descending: true)
            .limit(1)
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            int lastLoginTime = element.get('lastLoginTime');
            if (DateTime.now().millisecondsSinceEpoch > lastLoginTime) {
              _isLive = true;
            }
          });
        });

        SocialGroupModel socialGroupModel = new SocialGroupModel();
        socialGroupModel.sno = a['usedBy']['sno'].toString();
        socialGroupModel.name = a['usedBy']['name'];
        socialGroupModel.testPercent = testPercent;
        socialGroupModel.totalDimes = totalDimes;
        socialGroupModel.totalStudyHour = (((totalStudySecond / 3600) * 100).ceilToDouble() / 100);
        socialGroupModel.isUser = false;
        socialGroupModel.isLive = _isLive;
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
    double shapeSize = MediaQuery.of(context).size.width * 4 / 10;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Column(
                children: [
                  Text(
                    'Social Group',
                  ),
                  Text(
                    "Yesterday's Leader board",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(children: [
                Container(
                  height: height,
                  width: width,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.blue.withOpacity(0.2),
                        width: width * 5 / 10,
                        height: height,
                      ),
                      Container(
                        color: Colors.green.withOpacity(0.2),
                        width: width * 5 / 10,
                        height: height,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        width: shapeSize,
                                        height: shapeSize,
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage('assets/images/anshul.png'),
                                                radius: 50,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Align(
                                                      alignment: Alignment.lerp(Alignment.bottomLeft, Alignment.bottomRight, 0.20),
                                                      child: Container(
                                                        child: CircleAvatar(radius: 15, backgroundImage: AssetImage('assets/images/anshul.png')),
                                                        decoration: new BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: new Border.all(
                                                            color: Colors.deepPurple,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      )),
                                                  Align(
                                                      alignment: Alignment.lerp(Alignment.bottomLeft, Alignment.bottomRight, 0.40),
                                                      child: Container(
                                                        child: CircleAvatar(radius: 15, backgroundImage: AssetImage('assets/images/anshul.png')),
                                                        decoration: new BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: new Border.all(
                                                            color: Colors.deepPurple,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      )),
                                                  Align(
                                                      alignment: Alignment.lerp(Alignment.bottomLeft, Alignment.bottomRight, 0.60),
                                                      child: Container(
                                                        child: CircleAvatar(radius: 15, backgroundImage: AssetImage('assets/images/anshul.png')),
                                                        decoration: new BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: new Border.all(
                                                            color: Colors.deepPurple,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      )),
                                                  Align(
                                                      alignment: Alignment.lerp(Alignment.bottomLeft, Alignment.bottomRight, 0.80),
                                                      child: Container(
                                                        child: CircleAvatar(
                                                          foregroundColor: whiteColor,
                                                          backgroundColor: firstColor,
                                                          radius: 15,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                '20',
                                                                style: TextStyle(fontSize: 12),
                                                              ),
                                                              Icon(
                                                                Icons.add,
                                                                size: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        decoration: new BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: new Border.all(
                                                            color: Colors.deepPurple,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 4, color: Colors.blue[400]),
                                        ),
                                      ),
                                      Container(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => GroupBoard(),
                                              ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back_ios_rounded,
                                                    size: 18,
                                                    color: whiteColor,
                                                  ),
                                                  Text(
                                                    'Follower Group',
                                                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blue[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        width: shapeSize,
                                        height: shapeSize,
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundImage: AssetImage('assets/images/anshul.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 4, color: Colors.green[400]),
                                        ),
                                      ),
                                      Container(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => GroupBoard(),
                                              ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Leader Group',
                                                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 16),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 18,
                                                    color: whiteColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.green[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Card(
                            margin: EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.blue.withOpacity(0.6))),
                                      child: Column(
                                        children: [
                                          Card(
                                            clipBehavior: Clip.hardEdge,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  _changeFollowerField();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(_currentFollowerField == 1
                                                          ? 'Study Hours'
                                                          : _currentFollowerField == 2
                                                              ? 'Dimes'
                                                              : 'Test Percent'),
                                                      Icon(
                                                        Icons.swap_vertical_circle_sharp,
                                                        color: Colors.blue,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                                itemCount: followersList.length,
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
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  children: [
                                                                    Stack(
                                                                      alignment: Alignment.bottomRight,
                                                                      children: [
                                                                        Container(
                                                                          child: CircleAvatar(
                                                                            radius: 20,
                                                                            backgroundImage: AssetImage('assets/images/anshul.png'),
                                                                          ),
                                                                          decoration: new BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: new Border.all(
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
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            '#' + (i + 1).toString(),
                                                                            style: TextStyle(fontWeight: FontWeight.w600),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(_currentFollowerField == 1
                                                                              ? '${followersList[i].totalStudyHour} hours'
                                                                              : _currentFollowerField == 2
                                                                                  ? '${followersList[i].totalDimes} Dimes'
                                                                                  : '${followersList[i].testPercent} Test Percent'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.lerp(Alignment.topLeft, Alignment.topRight, 0.4),
                                                          child: Container(
                                                            width: 10,
                                                            height: 10,
                                                            margin: EdgeInsets.only(top: 5, right: 5),
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.green.withOpacity(0.6))),
                                      child: Column(
                                        children: [
                                          Card(
                                            clipBehavior: Clip.hardEdge,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  _changeLeaderField();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(_currentLeaderField == 1
                                                          ? 'Study Hours'
                                                          : _currentLeaderField == 2
                                                              ? 'Dimes'
                                                              : 'Test Percent'),
                                                      Icon(
                                                        Icons.swap_vertical_circle_sharp,
                                                        color: Colors.green,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                                itemCount: leadersList.length,
                                                itemBuilder: (BuildContext context, int i) {
                                                  bool _isActive = true;
                                                  bool _isOpened = false;
                                                  return Container(
                                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: i == 0 ? Border.all(width: 1, color: Colors.green[400]) : Border.all(width: 1, color: Colors.transparent),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Card(
                                                          clipBehavior: Clip.hardEdge,
                                                          margin: EdgeInsets.all(0),
                                                          child: Container(
                                                            color: Colors.green.withOpacity(0.2),
                                                            child: InkWell(
                                                              onTap: () {},
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '#' + (i + 1).toString(),
                                                                            style: TextStyle(fontWeight: FontWeight.w600),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(_currentLeaderField == 1
                                                                              ? '${leadersList[i].totalStudyHour} hours'
                                                                              : _currentLeaderField == 2
                                                                                  ? '${leadersList[i].totalDimes} Dimes'
                                                                                  : '${leadersList[i].testPercent} Test Percent'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Stack(
                                                                      alignment: Alignment.bottomRight,
                                                                      children: [
                                                                        Container(
                                                                          child: CircleAvatar(
                                                                            radius: 20,
                                                                            backgroundImage: AssetImage('assets/images/anshul.png'),
                                                                          ),
                                                                          decoration: new BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: new Border.all(
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
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.lerp(Alignment.topRight, Alignment.topLeft, 0.4),
                                                          child: Container(
                                                            width: 10,
                                                            height: 10,
                                                            margin: EdgeInsets.only(top: 5, right: 5),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  _changeFollowerField() {
    setState(() {
      if (_currentFollowerField == 1) {
        leadersList.sort((a, b) => a.totalDimes.compareTo(b.totalDimes));
        _currentFollowerField++;
      } else if (_currentFollowerField == 2) {
        leadersList.sort((a, b) => a.testPercent.compareTo(b.testPercent));
        _currentFollowerField++;
      } else if (_currentFollowerField == 3) {
        leadersList.sort((a, b) => a.totalStudyHour.compareTo(b.totalStudyHour));
        _currentFollowerField = 1;
      }
    });
  }

  _changeLeaderField() {
    setState(() {
      if (_currentLeaderField == 1) {
        leadersList.sort((a, b) => a.totalDimes.compareTo(b.totalDimes));
        _currentLeaderField++;
      } else if (_currentLeaderField == 2) {
        leadersList.sort((a, b) => a.testPercent.compareTo(b.testPercent));
        _currentLeaderField++;
      } else if (_currentLeaderField == 3) {
        leadersList.sort((a, b) => a.totalStudyHour.compareTo(b.totalStudyHour));
        _currentLeaderField = 1;
      }
    });
  }
}
