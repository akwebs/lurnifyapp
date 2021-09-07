import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/confitti.dart';
import 'package:lurnify/helper/helper.dart';
import 'package:lurnify/model/DataUpdate.dart';
import 'package:lurnify/widgets/home/reviews.dart';
import 'package:lurnify/widgets/home/spinner.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lurnify/widgets/widget.dart';
import 'package:lurnify/ui/screen/screen.dart';
import 'dart:async';

import 'constant/constant.dart';

import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _currentBackPressTime;

  var _data;
  Map<String, dynamic> resbody = Map();
  String _totalDimes = "0";
  bool isReferralCodeUsed = false;
  bool _isPaymentDone = false;
  bool _isSpinned = false;
  List<Map<String, dynamic>> _spinData = [];
  double _selfStudyPercent=0;
  double _testPercent=0;
  List<Map<String,dynamic>> _recentData=[];
  List<Map<String,dynamic>> _dueTopicTestData=[];

  _getHomePageData() async {
    try {
      bool showChallenge = false;
      DataUpdate dataUpdate = new DataUpdate();
      SharedPreferences sp = await SharedPreferences.getInstance();
      DataUpdateRepo dataUpdateRepo = new DataUpdateRepo();
      List<Map<String, dynamic>> list = await dataUpdateRepo.findBySno();
      if (list.isEmpty) {
        dataUpdate = new DataUpdate(
            beatDistraction: "1",
            dailyAppOpening: "1",
            dailyTask: "1",
            dailyTaskCompletion: "1",
            dailyTaskData: "1",
            reward: "1",
            timerPage: "1",
            weeklyTask: "1",
            challengeAccept: "1");
        String dateTimeNow = DateTime.now().toString();
        DataUpdate update = new DataUpdate(
            weeklyTask: dateTimeNow,
            timerPage: dateTimeNow,
            reward: dateTimeNow,
            dailyTaskData: dateTimeNow,
            dailyTaskCompletion: dateTimeNow,
            dailyTask: dateTimeNow,
            dailyAppOpening: dateTimeNow,
            beatDistraction: dateTimeNow,
            challengeAccept: dateTimeNow,
            dataSynced: dateTimeNow
        );

        dataUpdateRepo.insertIntoDataUpdate(update);
      } else {
        DataUpdate update = new DataUpdate();
        for (var a in list) {
          String dateTimeNow = DateTime.now().toString();
          if (a['reward'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['reward'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.reward = "1";
            update.reward = dateTimeNow;
          }
          if (a['weeklyTask'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['weeklyTask'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.weeklyTask = "1";
            update.weeklyTask = dateTimeNow;
          }
          if (a['dailyTaskCompletion'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['dailyTaskCompletion'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.dailyTaskCompletion = "1";
            update.dailyTaskCompletion = dateTimeNow;
          }
          if (a['dailyAppOpening'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['dailyAppOpening'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.dailyAppOpening = "1";
            update.dailyAppOpening = dateTimeNow;
          }
          if (a['dailyTask'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['dailyTask'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.dailyTask = "1";
            update.dailyTask = dateTimeNow;
          }
          if (a['dailyTaskData'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['dailyTaskData'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.dailyTaskData = "1";
            update.dailyTaskData = dateTimeNow;
          }
          if (a['beatDistraction'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['beatDistraction'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.beatDistraction = "1";
            update.beatDistraction = dateTimeNow;
          }
          if (a['timerPage'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['timerPage'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.timerPage = "1";
            update.timerPage = dateTimeNow;
          }
          if (a['challengeAccept'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['challengeAccept'])
                      .add(Duration(hours: 10))
                      .compareTo(DateTime.now()) <
                  1) {
            dataUpdate.challengeAccept = "1";
            update.challengeAccept = dateTimeNow;
          }

          if (a['dataSynced'] == null ||
              DateFormat('yyyy-MM-dd hh:mm')
                      .parse(a['dataSynced'])
                      .add(Duration(minutes: 2))
                      .compareTo(DateTime.now()) < 1) {

              DBHelper dbHelper = new DBHelper();
              Database db = await dbHelper.database;
              var batch = db.batch();

              RecentStudyRepo recentStudyRepo = new RecentStudyRepo();
              List<Map<String,dynamic>> recentStudys=await recentStudyRepo.getNewRecentStudy();

              for(var a in recentStudys){
                Map<String,dynamic> m = Map.of(a);
                m.update('status', (value) => 'old',ifAbsent: () => 'old',);

                batch.rawUpdate("update recent_study set status='old' where sno=${a['sno']}");
                await FirebaseFirestore.instance.collection('recentStudy').add(m);
              }

              DueTopicTestRepo dueTopicTestRepo = new DueTopicTestRepo();
              List<Map<String,dynamic>> dueTests=await dueTopicTestRepo.getNewDueTopicTest();
              for(var a in dueTests){
                Map<String,dynamic> m = Map.of(a);
                m.update('onlineStatus', (value) => 'old',ifAbsent: () => 'old',);

                batch.rawUpdate("update due_topic_tests set onlineStatus='old' where sno=${a['sno']}");
                await FirebaseFirestore.instance.collection('dueTopicTests').add(m);
              }

              StudyRepo studyRepo = new StudyRepo();
              List<Map<String,dynamic>> studys=await studyRepo.getNewStudy();

              for(var a in studys){
                Map<String,dynamic> m = Map.of(a);
                m.update('status', (value) => 'old',ifAbsent: () => 'old',);

                batch.rawUpdate("update study set status='old' where sno=${a['sno']}");
                await FirebaseFirestore.instance.collection('study').add(m);
              }

              DimeRepo dimeRepo = new DimeRepo();
              List<Map<String,dynamic>> dimes=await dimeRepo.getNewDimes();
              for(var a in dimes){
                Map<String,dynamic> m = Map.of(a);
                m.update('status', (value) => 'old',ifAbsent: () => 'old',);

                String sql="update dimes set status='old' where sno='${a['sno']}'";
                batch.rawUpdate(sql);

                await FirebaseFirestore.instance.collection('dimes').add(m);
              }

              TopicTestResultRepo topicTestResultRepo = new TopicTestResultRepo();
              List<Map<String,dynamic>> topicResults=await topicTestResultRepo.getNewTopicTestResult();
              for(var a in topicResults){
                Map<String,dynamic> m = Map.of(a);
                m.update('status', (value) => 'old',ifAbsent: () => 'old',);

                batch.rawUpdate("update topic_test_result set status='old' where sno=${a['sno']}");
                await FirebaseFirestore.instance.collection('topicTestResult').add(m);
              }

              DailyTaskCompletionRepo dailyTaskCompletionRepo = new DailyTaskCompletionRepo();
              List<Map<String,dynamic>> dailyResult=await dailyTaskCompletionRepo.getNewDailyTaskCompletion();
              for(int i=0;i<dailyResult.length;i++){
                batch.rawUpdate("update daily_task_completion set onlineStatus='old' where sno=${dailyResult[i]['sno']}");
                Map<String,dynamic> m = Map.of(dailyResult[i]);
                m.update('onlineStatus', (value) => 'old',ifAbsent: () => 'old',);
                await FirebaseFirestore.instance.collection('dailyTaskCompletion').add(m);
              }

              batch.commit();
          }
        }
      }
      String registerSno=sp.getString("studentSno");
      var url =
          baseUrl + "getHomePageData?registerSno=" + registerSno;
      print(url);
      http.Response response = await http.post(Uri.encodeFull(url),
          body: jsonEncode(dataUpdate.toJson()));

      resbody = jsonDecode(response.body);

      isReferralCodeUsed = resbody['isReferralCodeUsed'];
      _isPaymentDone = resbody['isPaymentDone'];
      // _isSpinned = resbody['isSpinned'];
      DBHelper dbHelper = new DBHelper();
      Database database = await dbHelper.database;

      await database.transaction((txn) async {
        if (resbody.containsKey('reward')) {
          txn.delete('reward');
          print("reward deleted");
          txn.insert('reward', jsonDecode(resbody['reward']));
          print("reward inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from reward");
          print("reward printing");
          print(list);
        }

        if (resbody.containsKey('weeklyTask')) {
          txn.delete('weekly_task');
          print("weeklyTask deleted");
          List datas = jsonDecode(resbody['weeklyTask']);
          for (var a in datas) {
            txn.insert('weekly_task', a);
          }
          print("weeklyTask inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from weekly_task");
          print("weeklyTask printing");
          print(list);
        }

        if (resbody.containsKey('dailyTaskCompletion')) {
          txn.delete('daily_task_completion');
          print("daily_task_completion deleted");
          List datas = jsonDecode(resbody['dailyTaskCompletion']);
          for (var a in datas) {
            txn.insert('daily_task_completion', a);
          }
          print("daily_task_completion inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from daily_task_completion");
          print("daily_task_completion printing");
          print(list);
        }

        if (resbody.containsKey('dailyTask')) {
          txn.delete('daily_task');
          print("dailyTask deleted");
          List datas = jsonDecode(resbody['dailyTask']);
          for (var a in datas) {
            txn.insert('daily_task', a);
          }
          print("dailyTask inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from daily_task");
          print("daily_task printing");
        }

        if (resbody.containsKey('dailyTaskData')) {
          txn.delete('daily_task_data');
          print("dailyTaskData deleted");
          List datas = jsonDecode(resbody['dailyTaskData']);
          for (var a in datas) {
            txn.insert('daily_task_data', a);
          }
          print("dailyTaskData inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from daily_task_data");
          print("dailyTaskData printing");
        }

        if (resbody.containsKey('beatDistraction')) {
          txn.delete('beat_distraction');
          print("beat_distraction deleted");
          List datas = jsonDecode(resbody['beatDistraction']);
          for (var a in datas) {
            txn.insert('beat_distraction', a);
          }
          print("beat_distraction inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from beat_distraction");
          print("beat_distraction printing");
        }

        if (resbody.containsKey('dailyAppOpening')) {
          txn.delete('daily_app_opening');
          print("daily_app_opening deleted");
          List datas = jsonDecode(resbody['dailyAppOpening']);
          for (var a in datas) {
            txn.insert('daily_app_opening', a);
          }
          print("daily_app_opening inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from daily_app_opening");
          print("daily_app_opening printing");
        }

        if (resbody.containsKey('timerPage')) {
          txn.delete('timer_page_message');
          print("timer_page_message deleted");
          List datas = jsonDecode(resbody['timerPage']);
          for (var a in datas) {
            txn.insert('timer_page_message', a);
          }
          print("timer_page_message inserted");
          List<Map<String, dynamic>> list =
              await txn.rawQuery("select * from timer_page_message");
          print("timer_page_message printing");
        }

        if (resbody.containsKey("challengeAccept")) {
          txn.insert(
              'challenge_accept', jsonDecode(resbody['challengeAccept']));
          print("challenge_accept inserted");
          showChallenge = true;
        }

        DimeRepo dimeRepo = new DimeRepo();

        List<Map<String, dynamic>> totalDimeList = await dimeRepo
            .getTotalDimesByRegister(sp.getString("studentSno"), txn);

        setState(() {
          for (var a in totalDimeList) {
            _totalDimes = a['totalDimes'].toString();
          }
        });


        //Checking daily app opening
        String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String sql =
            "select * from daily_app_opening where registerSno=${sp.getString("studentSno")} and appOpeningDate = $date";
        List<Map<String, dynamic>> dailyAppOpeningList =
        await txn.rawQuery(sql);
        if (dailyAppOpeningList.isEmpty) {
          await txn.rawQuery(
              "insert into daily_app_opening(appOpeningDate,registerSno,enteredDate) values('$date','${sp.getString("studentSno")}','${DateTime.now()}')");
          List<Map<String, dynamic>> list = await txn
              .rawQuery("select * from reward order by sno desc limit 1");
          for (var a in list) {
            var credit = a['appOpening'];
            String sql2 =
                "insert into dimes(credit,debit,message,enteredDate,registerSno) "
                "values('$credit','0','Daily app opening reward','${DateTime.now().toString()}','${sp.getString("studentSno")}')";
            await txn.rawQuery(sql2);
          }
        }



        String sql2 =
            "select * from daily_task_completion where spinDate='${DateTime.now().toString().split(" ")[0]}' and registerSno=${sp.getString('studentSno')}";
        List<Map<String, dynamic>> list2 = await txn.rawQuery(sql2);
        if (list2.isEmpty) {
          _isSpinned=false;
          String sql =
              "select * from daily_task where '$date'>=startDateTime and '$date'<=endDateTime and status='enable' order by random() limit 6";
          List<Map<String, dynamic>> list = await txn.rawQuery(sql);
          for (var a in list) {
            Map<String, dynamic> map = Map();
            map.putIfAbsent('taskName', () => a['taskName']);
            map.putIfAbsent('sno', () => a['sno']);
            String sql2 =
                "select * from daily_task_data where dailyTaskSno=${a['sno']}";
            List<Map<String, dynamic>> list = await txn.rawQuery(sql2);
            map.putIfAbsent("dailyTaskDatas", () => list);
            _spinData.add(map);
          }
          if (_spinData.length < 6) {
            _spinData=[];
            String sql2 = "select * from daily_task order by random() limit 6";
            List<Map<String,dynamic>> list = await txn.rawQuery(sql2);
            for (var a in list) {
              Map<String, dynamic> map = Map();
              map.putIfAbsent('taskName', () => a['taskName']);
              map.putIfAbsent('sno', () => a['sno']);
              String sql2 =
                  "select * from daily_task_data where dailyTaskSno=${a['sno']}";
              List<Map<String, dynamic>> list = await txn.rawQuery(sql2);
              map.putIfAbsent("dailyTaskDatas", () => list);
              _spinData.add(map);
            }
          }
        }else{
          _isSpinned=true;
        }

        //Getting data for home page
        String sql3="select count(sno) as totalTopic,"
            "(select count(sno) from study where topicCompletionStatus='Complete' and revision=0 group by topicSno) as completedTopics"
            " from topic";
        List<Map<String,dynamic>> list4=await txn.rawQuery(sql3);
        for(var a in list4){
          if(a['totalTopic']!=null && a['totalTopic']!=0){
            _selfStudyPercent=a['totalTopic']/a['totalTopic'];
          }
        }

        String sql4="select (sum(correctQuestion)/sum(totalQuestion)) as testPercent from topic_test_result";
        List<Map<String,dynamic>> list5=await txn.rawQuery(sql4);
        for(var a in list5){
            _testPercent=a['testPercent'];
        }

        //Getting recent data
        RecentStudyRepo recentStudyRepo = new RecentStudyRepo();
        _recentData=await recentStudyRepo.getRecentStudyForHomePage(txn);

        //Getting due topic tests
        DueTopicTestRepo dueTopicTestRepo = new DueTopicTestRepo();
        _dueTopicTestData=await dueTopicTestRepo.getHomePageDueTest(txn);


      });


        int lastLoginTime=DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch;
        await FirebaseFirestore.instance.collection('lastOnline').add({
        'register':registerSno,
        'lastLoginTime':lastLoginTime
      });

      if (showChallenge) {
        _showChallenge();
      } else {
        _showMyDialog();
      }
    } catch (e) {
      print("-----------------------");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _data = _getHomePageData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Press BACK again to Exit', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserProfile(),
      ));
    }
    if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Confetti(),
      ));
    }
  }

  static List pageKey = [
    'self_study',
    'rank_booster',
    'my_report',
    'course_content',
    'syllbus_progress',
    'revision_zone',
    'dare_to_do',
    'my_reward',
    'money_matters',
  ];

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Image.asset(
                logoUrl,
                fit: BoxFit.contain,
                height: 40,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        'Hey Check out this cool app, https://lurnify.in/');
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Settings', 'Logout'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white24,
              ),
              child: Drawer(
                elevation: 0,
                child: CustomDrawer(_isPaymentDone),
              ),
            ),
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple[100].withOpacity(0.1),
                      Colors.deepPurple[100].withOpacity(0.1)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      CardWidget(_selfStudyPercent,_testPercent),
                      AppTiles(pageKey),
                      BottomSlider(pageKey,_recentData),
                      TestSlider(_dueTopicTestData),
                      Container(
                        color: Colors.grey.withOpacity(0.1),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 15, 8, 10),
                              child: Text(
                                'Hear from delighted users',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Reviews(
                              clr: AppColors.cardHeader[2],
                            ),
                            Reviews(
                              clr: AppColors.cardHeader[1],
                            ),
                            Reviews(
                              clr: AppColors.cardHeader[0],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Recent('1'),
                ));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.store),
                  label: 'Store',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Group',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          );
        });
  }

  void _signUpToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  Future<void> _showChallenge() async {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Challenge',
        desc:
            "You have given a challenge for next monday. Do you want to accept it and want to earn coin?",
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        btnOkColor: Colors.black87,
        btnOkText: "Accept",
        btnOkOnPress: () {
          _updateChallengeStatus("accepted");
          if (resbody['dailyReward'] == true) {
            _showDailyAppOpening();
          }
        },
        btnCancelText: "Cancel",
        btnCancelColor: Colors.black,
        btnCancelOnPress: () {
          _updateChallengeStatus("declined");
          if (resbody['dailyReward'] == true) {
            _showDailyAppOpening();
          }
        })
      ..show();
  }

  Future<void> _showMyDialog() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Welcome to lurnify',
      desc:
          "Study for only one hour this week and start earning real money.\n To know more about lurnify's digital coin please click on know more.",
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Know More",
      btnOkOnPress: () {
        if (resbody['dailyReward'] == true) {
          _showDailyAppOpening();
        } else {
          print("---------------------------------------$_isSpinned");
          if (_spinData.isNotEmpty && _isSpinned) {
            _showSpinWheel();
          } else {
            print("SPIN DATA EMPTY");
          }
        }
      },
    )..show();
  }

  Future<void> _showDailyAppOpening() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: "You have earned " +
          resbody['dimes'].toString() +
          " dimes as daily reward",
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {
        if (_spinData.isNotEmpty) {
          _showSpinWheel();
        } else {
          print("SPIN DATA EMPTY");
        }
      },
    )..show();
  }

  _showSpinWheel() async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) {
          return new SpinnerClass(_spinData);
        });
  }

  _updateChallengeStatus(status) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // var url = baseUrl +
    //     "updateChallengeStatus?registerSno=" +
    //     sp.getString("studentSno") +
    //     "&status=" +
    //     status;
    // print(url);
    // http.Response response = await http.post(
    //   Uri.encodeFull(url),
    // );

    DBHelper dbHelper = new DBHelper();
    Database database = await dbHelper.database;
    String sql =
        "select * from challenge_accept where register=${sp.getString("studentSno")} and status='pending'";
    List<Map<String, dynamic>> list = await database.rawQuery(sql);
    for (var a in list) {
      String sql2 =
          "update challenge_accept set status=$status where sno=${a['sno']}";
      database.rawUpdate(sql2);
    }

    if (status == 'accepted') {
      List<Map<String, dynamic>> list = await database
          .rawQuery("select * from reward order by sno desc limit 1");
      for (var a in list) {
        String sql =
            "insert into dimes (credit,register,enteredDate,message,debit) values('${a['weeklyChallengeAccept']}','${sp.getString("studentSno")}',"
            "'${DateTime.now().toString()}','Weekly challenge accepted reward','0')";
        await database.rawInsert(sql);
      }
    }

    if (status == "accepted") {
      _signUpToast(
          "Congratulations, you have accepted the challenge. Start Study and earn real money");
    } else {
      _signUpToast(
          "OOPS!!! you have declined the challenge. Don't worry! you can enroll in upcoming and challenges and still you can make money.");
    }
  }
}
