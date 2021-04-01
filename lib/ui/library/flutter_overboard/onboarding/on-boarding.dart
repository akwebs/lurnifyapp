import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/library/flutter_overboard/overboard.dart';
import 'package:lurnify/ui/library/flutter_overboard/page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding1Page extends StatefulWidget {
  @override
  _Onboarding1PageState createState() => _Onboarding1PageState();
}

class _Onboarding1PageState extends State<Onboarding1Page> {
  // create each page of onBoard here
  SharedPreferences sp;
  final _pageList = [
    PageModel(
        color: Colors.white,
        imageAssetPath: 'assets/images/onboarding/img1.png',
        title: 'Self Study',
        body: 'This is description of tutorial 1. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageAssetPath: 'assets/images/onboarding/img2.png',
        title: 'Self Study',
        body: 'This is description of tutorial 2. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageAssetPath: 'assets/images/onboarding/img3.png',
        title: 'Your Personal AI',
        body: 'This is description of tutorial 3. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageAssetPath: 'assets/images/onboarding/img1.png',
        title: 'Get Started',
        body: 'This is description of tutorial 4. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
  ];

  @override
  void initState() {
    _initializeSp();
    super.initState();
  }

  _initializeSp() async {
    sp = await SharedPreferences.getInstance();
    sp.setBool("onboarding", true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: OverBoard(
        pages: _pageList,
        showBullets: true,
        finishCallback: () {
          Fluttertoast.showToast(
              msg: 'Click finish',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black54);
          if (sp.getString("studentSno") != null) {
            Navigator.of(context).pushNamed(home_page);
          } else {
            Navigator.of(context).pushNamed(Log_in);
          }
        },
      ),
    ));
  }
}
