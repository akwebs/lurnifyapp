import 'package:flutter/material.dart';

String globalUrl = "";

Color whiteColor = Colors.white;
Color secondColor = Color(0xff54d676);
Color thirdColor = Color(0xff945cb4);
Color backgroundColor = Colors.deepPurple[300];

Color firstColor = Colors.deepPurple;
Color borderColor = Colors.deepPurpleAccent;
Color textColor = Colors.deepPurple;

enum ResponsiveSize { WIDTH, HEIGHT }

enum ViewState {
  Idle,
  Busy // Future processings
}
// LogManager

enum LogAction {
  CALLED,
  PRESSED,
  HTTP_RESPONSE,
  HTTP_REQUEST, // post/get/put/delete...
  API_LOG,
}

enum DevelopmentMode {
  TESTING, //expanded use trace, time etc...
  DEVELOPMENT,
  PRODUCTION,
  CUSTOM_OPTION // additional
}

enum ApiLog { ACTIVE, PASSIVE }

enum ApiEndPoint {
  TEST, //json palceholder
  PRODUCTION, // production real
}

class Responsive {
  Responsive._privateConstructor();

  static final Responsive _instance = Responsive._privateConstructor();

  static Responsive get instance => _instance;

  static double findPercent(
      double value, ResponsiveSize sizeType, BuildContext context) {
    double getFullSize;

    if (sizeType == ResponsiveSize.WIDTH) {
      getFullSize = MediaQuery.of(context).size.width;
    } else if (sizeType == ResponsiveSize.HEIGHT) {
      getFullSize = MediaQuery.of(context).size.height;
    }

    return value * 100 / getFullSize;
  }

  // ignore: missing_return
  static double getPercent(
      double percent, ResponsiveSize sizeType, BuildContext context) {
    if (sizeType == ResponsiveSize.WIDTH) {
      return MediaQuery.of(context).size.width * percent / 100;
    } else if (sizeType == ResponsiveSize.HEIGHT) {
      return MediaQuery.of(context).size.height * percent / 100;
    }
  }
}

class NewappColors {
  static Color primaryWhite = Color(0xFFCADCED);
  static Color primaryColor = Colors.deepPurple;
  static Color onprimaryColor = Colors.white;
  // static Color primaryWhite = Colors.indigo[100];

  static List<BoxShadow> neumorpShadow = [
    BoxShadow(
        color: Colors.black12.withOpacity(.1),
        offset: Offset(2, 2),
        blurRadius: 5)
  ];
}

class NewappSlider {
  static List percent = [
    35,
    40,
    75,
    86,
  ];
  static List text = [
    'DPP',
    'TEST',
    'ATTENDENCE',
    'REPORT',
  ];
  static List name = [
    'Self Study',
    'Challenges',
    'Report',
    'Profile',
  ];
  static List subName = [
    'Physics',
    'Chemistry',
    'Maths',
    'Biology',
  ];
  static List<Color> subColors = [
    Colors.amber,
    Colors.green,
    Colors.blue,
    Colors.redAccent,
  ];
}
