import 'dart:ui';

import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/ui/screen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("studentSno");
    sp.remove("courseSno");
    sp.remove("courseCompletionDate");
    sp.remove("courseCompletionDateFormatted");
    sp.remove("courseStartingDate");
    sp.remove("totalWeeks");
    sp.remove("totalStudyHour");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
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
