import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../../helper/db_helper.dart';
import '../../constant/constant.dart';
import '../../constant/routes.dart';
import '../../../widgets/componants/custom_button.dart';
import '../myProgress/subject_unit.dart';
import '../socialGroup/social_group.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _completedTopics = "0";
  String _completedChapters = "0";
  String _completedUnits = "0";
  double _perDatStudyHour = 0;
  List<Map<String, dynamic>> _streaks = [];

  _getData() async {
    DBHelper dbHelper = new DBHelper();
    Database db = await dbHelper.database;
    db.transaction((txn) async {
      String sql = "select count(sno) as completedUnits from completed_units";
      List<Map<String, dynamic>> list = await txn.rawQuery(sql);

      String sql2 = "select count(sno) as completedChapters from completed_chapters";
      List<Map<String, dynamic>> list2 = await txn.rawQuery(sql2);

      String sql3 = "select count(sno) as completedTopics from study"
          " where topic_completion_status='Complete' "
          "and revision='0' "
          "group by topicSno";
      List<Map<String, dynamic>> list3 = await txn.rawQuery(sql3);

      String perDayStudyHour = "0";
      String sql4 = "select perDayStudyHour from pace";
      List<Map<String, dynamic>> list4 = await txn.rawQuery(sql4);
      for (var a in list4) {
        perDayStudyHour = a['perDayStudyHour'];
      }
      _perDatStudyHour = double.tryParse(perDayStudyHour);

      String sql5 = "SELECT sum(totalSecond)/3600 as totalSecond FROM study WHERE date > (SELECT DATETIME('now', '-7 day') group by date)";
      _streaks = await txn.rawQuery(sql5);

      for (var a in list) {
        _completedUnits = a['completedUnits'].toString();
      }

      for (var a in list2) {
        _completedChapters = a['completedChapters'].toString();
      }

      for (var a in list3) {
        _completedTopics = a['completedTopics'].toString();
      }

      return null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          "Aman Sharma",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Joined June 2021',
                          style: TextStyle(color: firstColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: _ProgressBar(
                              progressValue: 40,
                              task: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage('assets/images/anshul.png'),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(height: 50, width: 50, child: Image.asset('assets/award.png')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SocialGroup(),
                        ));
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        width: MediaQuery.of(context).size.width * 4 / 10,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.0),
                              child: Container(
                                child: CircleAvatar(radius: 15, backgroundImage: AssetImage('assets/images/anshul.png')),
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    color: Colors.deepPurple,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.15),
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
                                alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.3),
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
                                alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.45),
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
                                alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.60),
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
                            Align(
                              alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 1.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: new Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Divider(
                          height: 10,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Progress Summary',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyProgress(),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _completedUnits,
                                        style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Unit Completed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _completedChapters,
                                        style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Chapter Completed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _completedTopics,
                                        style: TextStyle(color: Colors.deepPurple[300], fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Topic Completed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '2 Days',
                                      style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.w600, fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Streak',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: _customCircularIndicator(),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                        ),
                        InkWell(
                          onTap: () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (builder) {
                                  return UserProfileEdit();
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Edit Profile'),
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                        ),
                      ],
                    ),
                  ),
                ],
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
        buttonText: 'Update Study Pace',
        brdRds: 0,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(selectPace);
        },
      ),
    );
  }

  Widget _customCircularIndicator() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, i) {
          double percent = 0;
          if (_streaks.asMap().containsKey(i)) {
            percent = _streaks[i]['totalSecond'] / _perDatStudyHour;
          }
          return Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CircularPercentIndicator(
              radius: 30,
              lineWidth: 3.0,
              animation: true,
              percent: percent,
              backgroundColor: Color.fromARGB(30, 128, 112, 254),
              circularStrokeCap: CircularStrokeCap.round,
              linearGradient: LinearGradient(
                colors: <Color>[Colors.deepPurpleAccent, Colors.deepPurple],
                stops: <double>[0.25, 0.75],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserProfileEdit extends StatefulWidget {
  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  // Color _color1 = firstColor;
  Color _color2 = Color(0xff777777);
  // Color _color3 = Color(0xFF515151);

  File _selectedImage;
  final picker = ImagePicker();

  firebase_storage.Reference ref;
  bool _savePressed = false;
  CollectionReference _registerRef;

  @override
  void initState() {
    _registerRef = FirebaseFirestore.instance.collection('register');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 8 / 10,
        child: Card(
          margin: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PreferredSize(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(top: 5, right: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 2,
                            child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                        ),
                      ],
                    ),
                    preferredSize: Size.fromHeight(50)),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _createProfilePicture(),
                      SizedBox(height: 40),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Robert Steven',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(msg: 'Click edit name', toastLength: Toast.LENGTH_SHORT);
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 15,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Email',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'robert.steven@ijteknologi.com',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 15,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Phone Number',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(height: 8),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    '0811888999',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit phone number', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Date of Birth',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    '22/08/1996',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Father Name',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    'Mr. Falcon John',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Current Class',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    'XI',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Target',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    'JEE 2023',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'School Name',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    'Laowrence and Mayo',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Marks in 10th',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    '9.2 CGPA',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Marks in 12th',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    '- - -',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Address',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    'Kota, Rajasthan',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Email',
                                style: TextStyle(fontSize: 12, color: _color2, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: Text(
                                    'robert.steven@ijteknologi.com',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: 'Click edit email', toastLength: Toast.LENGTH_SHORT);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                              ]),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createProfilePicture() {
    final double profilePictureSize = MediaQuery.of(context).size.width * 4 / 10;
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 40),
        width: profilePictureSize,
        height: profilePictureSize,
        child: GestureDetector(
          onTap: () {
            _showPopupUpdatePicture();
          },
          child: Stack(
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    _chooseImage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: (profilePictureSize),
                    child: Hero(
                      tag: 'profilePicture',
                      child: ClipOval(
                        child: SizedBox(
                          width: profilePictureSize,
                          height: profilePictureSize,
                          child: Image.asset('assets/images/anshul.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Colors.deepPurple,
                    width: 3.0,
                  ),
                ),
              ),
              // create edit icon in the picture
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width / 4),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                  child: Icon(
                    Icons.edit,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupUpdatePicture() {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: firstColor)));
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'Click edit profile picture', toastLength: Toast.LENGTH_SHORT);
        },
        child: Text('Yes', style: TextStyle(color: firstColor)));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'Edit Profile Picture',
        style: TextStyle(fontSize: 18),
      ),
      content: Text('Do you want to edit profile picture ?', style: TextStyle(fontSize: 13, color: _color2)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _chooseImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _selectedImage = File(pickedFile?.path);
    });
    if (pickedFile.path == null) _retrieveLostData();
  }

  Future<void> _retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _selectedImage = File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }

  Future _uploadFile() async {
    if (_savePressed) {
    } else if (_selectedImage == null) {
      Fluttertoast.showToast(msg: "Please select Image");
    } else {
      setState(() {
        _savePressed = true;
      });
      SharedPreferences sp = await SharedPreferences.getInstance();
      String register = sp.getString('studentSno');
      ref = firebase_storage.FirebaseStorage.instance.ref().child('images/${Path.basename(_selectedImage.path)}');
      await ref.putFile(_selectedImage).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _registerRef.add({'url': value, 'register': register}).whenComplete(() {
            Fluttertoast.showToast(msg: "Saved");
            setState(() {
              _savePressed = false;
            });
          });
        });
      });
    }
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({Key key, @required this.progressValue, @required this.task}) : super(key: key);

  final double progressValue;
  final Widget task;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              positionFactor: 0.1,
              angle: 90,
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  task,
                ],
              ))
        ],
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        axisLineStyle: AxisLineStyle(
          thickness: 0.1,
          cornerStyle: CornerStyle.bothCurve,
          color: Color.fromARGB(30, 128, 112, 254),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
              value: progressValue.isNaN ? 0 : progressValue,
              width: 0.1,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
              gradient: const SweepGradient(colors: <Color>[Colors.lightGreen, Colors.green], stops: <double>[0.25, 0.75])),
          MarkerPointer(
            markerHeight: 9,
            markerWidth: 9,
            value: progressValue.isNaN ? 0 : progressValue,
            markerType: MarkerType.circle,
            color: Colors.green,
          )
        ],
      )
    ]);
  }
}
