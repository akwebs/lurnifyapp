import 'dart:ui';

import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
