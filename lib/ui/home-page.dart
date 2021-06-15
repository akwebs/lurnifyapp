import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/selfstudy/recent.dart';
import 'package:lurnify/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/widgets/home/apptiles.dart';
import 'package:lurnify/widgets/home/bottom_slider.dart';
import 'package:lurnify/widgets/home/cards_Slider.dart';
import 'package:lurnify/widgets/home/cardwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'dart:async';

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
  List _spinData = [];

  _getHomePageData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url =
        baseUrl + "getHomePageData?registerSno=" + sp.getString("studentSno");
    print(url);
    http.Response response = await http.post(
      Uri.encodeFull(url),
    );
    resbody = jsonDecode(response.body);
    setState(() {
      _totalDimes = resbody['totalDimes'].toString();
      _signUpToast(_totalDimes);
    });
    if (resbody['result'] == true) {
      _showChallenge();
    } else {
      _showMyDialog();
    }
    isReferralCodeUsed = resbody['isReferralCodeUsed'];
    _isPaymentDone = resbody['isPaymentDone'];
    _isSpinned = resbody['isSpinned'];
    if (resbody.containsKey("spinData")) {
      _spinData = jsonDecode(resbody['spinData']);
    }
    print(_spinData);
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
                'assets/lurnify.png',
                fit: BoxFit.contain,
                height: 40,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            iconTheme: IconThemeData(color: Colors.deepPurple),
                            backgroundColor: Colors.white,
                            title: const Text(
                              'Notifications',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          body: const Center(
                            child: Text(
                              'This is the Notification Page',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      },
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
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
            body: Container(
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      CardWidget(),
                      AppTiles(pageKey),
                      BottomSlider(pageKey),
                      TestSlider(),
                    ],
                  ),
                ),
              ),
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
            ),
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
          if (_spinData.isNotEmpty) {
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
    var url = baseUrl +
        "updateChallengeStatus?registerSno=" +
        sp.getString("studentSno") +
        "&status=" +
        status;
    print(url);
    http.Response response = await http.post(
      Uri.encodeFull(url),
    );
    Map<String, dynamic> resbody = jsonDecode(response.body);
    print(resbody);
    if (resbody['result'] == true) {
      if (status == "accepted") {
        _signUpToast(
            "Congratulations, you have accepted the challenge. Start Study and earn real money");
      } else {
        _signUpToast(
            "OOPS!!! you have declined the challenge. Don't worry! you can enroll in upcoming and challenges and still you can make money.");
      }
    } else {
      _signUpToast("OOPS!!! Something went wrong. Please try again later");
    }
  }
}

class SpinnerClass extends StatefulWidget {
  final _spinData;
  SpinnerClass(this._spinData);
  @override
  _SpinnerClassState createState() => _SpinnerClassState(_spinData);
}

class _SpinnerClassState extends State<SpinnerClass> {
  final _spinData;
  _SpinnerClassState(this._spinData);
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: Responsive.getPercent(
                        100, ResponsiveSize.WIDTH, context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Spin to Win',
                        style: TextStyle(fontSize: 22, color: whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.1)),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 250.0,
                    color: Colors.transparent,
                    child: FortuneWheel(
                      indicators: [
                        FortuneIndicator(
                            child: TriangleIndicator(
                              color: Colors.white,
                            ),
                            alignment: Alignment.bottomCenter)
                      ],
                      physics: CircularPanPhysics(
                        duration: Duration(seconds: 1),
                        curve: Curves.decelerate,
                      ),
                      duration: Duration(seconds: 10),
                      animateFirst: false,
                      selected: _selected,
                      onAnimationEnd: () {
                        _updateDailyTask();
                      },
                      items: List.generate(
                        _spinData.length,
                        (index) {
                          return FortuneItem(
                              child: Text(_spinData[index]['taskName']));
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () {
                        try {
                          print(_selected);
                          var _random = new Random();
                          setState(() {
                            _selected = _random.nextInt(6);
                            print(_selected);
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'SPIN',
                          style: TextStyle(fontSize: 22, color: whiteColor),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                            ),
                          ],
                          shape: BoxShape.circle,
                          gradient: AppSlider.gradient[3],
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
    );
  }

  _updateDailyTask() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl +
        "storeSpinData?registerSno=" +
        sp.getString("studentSno") +
        "&dailyTaskSno=" +
        _spinData[_selected - 1]['sno'].toString();
    print(url);
    http.Response response = await http.post(
      Uri.encodeFull(url),
    );
    Map<String, dynamic> resbody = jsonDecode(response.body);
    if (resbody['result'] == true) {
      Fluttertoast.showToast(msg: "Success");

      _showSpinTask();
    } else {
      Fluttertoast.showToast(msg: "Failed");
    }
  }

  Future<void> _showSpinTask() async {
    String result = "";
    List data = _spinData[_selected - 1]['dailyTaskDatas'];
    for (int i = 0; i < data.length; i++) {
      result = result +
          "Your task type is" +
          data[i]['taskType'] +
          " and you have to complete " +
          data[i]['taskUnit'].toString() +
          "test or study minute\nAnd you will be rewarded with " +
          data[i]['coins'].toString() +
          " Coins or " +
          data[i]['cash'].toString() +
          " cash or " +
          data[i]['certificate'].toString() +
          " certificates or " +
          data[i]['noOfReferralCoupons'].toString() +
          " refferals coupons\n";
    }
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: result,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    )..show();
  }
}
