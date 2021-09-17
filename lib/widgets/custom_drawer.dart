import 'dart:ui';

import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/ui/home_page.dart';
import 'package:lurnify/ui/screen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lurnify/ui/screen/payment/make_payment.dart';
import 'package:lurnify/ui/screen/marketPlace/purchased_item.dart';
import 'package:sqflite/sqflite.dart';

class CustomDrawer extends StatefulWidget {
  final isPaymentDone;
  CustomDrawer(this.isPaymentDone);

  @override
  _CustomDrawerState createState() => _CustomDrawerState(isPaymentDone);
}

class _CustomDrawerState extends State<CustomDrawer> {
  var isPaymentDone;
  _CustomDrawerState(this.isPaymentDone);

  logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("studentSno");
    sp.remove("courseSno");
    sp.remove("courseCompletionDate");
    sp.remove("courseCompletionDateFormatted");
    sp.remove("courseStartingDate");
    sp.remove("totalWeeks");
    sp.remove("totalStudyHour");
    DBHelper dbHelper = new DBHelper();
    Database database = await dbHelper.database;
    database.delete('course_group');
    database.delete('course');
    database.delete('subject');
    database.delete('unit');
    database.delete('chapter');
    database.delete('topic');
    database.delete('study');
    database.delete('reward');
    database.delete('dimes');
    database.delete('recent_study');
    database.delete('due_topic_tests');
    database.delete('remark');
    database.delete('pace');
    database.delete('topic_test_result');
    database.delete('test_main');
    database.delete('test');
    database.delete('instruction');
    database.delete('instruction_data');
    database.delete('register');
    database.delete('weekly_task');
    database.delete('daily_task_completion');
    database.delete('daily_task');
    database.delete('daily_task_data');
    database.delete('data_update');
    database.delete('beat_distraction');
    database.delete('daily_app_opening');
    database.delete('timer_page_message');
    database.delete('challenge_accept');
    database.delete('completed_chapters');
    database.delete('completed_units');
    database.delete('completed_subjects');

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: double.infinity,
          decoration: BoxDecoration(boxShadow: NewappColors.neumorpShadow),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.transparent),
                  accountName: Text('Anil Kumar Jangid'),
                  accountEmail: Text('me@akwebs.in'),
                  currentAccountPicture: Container(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/anshul.png'),
                    ),
                    decoration: new BoxDecoration(
                      boxShadow: NewappColors.neumorpShadow,
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.deepPurple,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text('Home'),
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                ),
                ListTile(
                  title: Text("Make Payment"),
                  leading: Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MakePayment(isPaymentDone),
                    ));
                  },
                ),
                ListTile(
                  title: Text("Purchased Items"),
                  leading: Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PurchasedItem(),
                    ));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text('Home'),
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text('Home'),
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.login_outlined,
                  ),
                  title: Text('Log Out'),
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  onTap: () {
                    Navigator.pop(context);
                    logout();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
