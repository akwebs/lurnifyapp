import 'package:flutter/material.dart';

class AppColors {
  static Color primaryWhite = Colors.white;
  static Color secondoryWhite = Colors.indigo;

  // static Color primaryWhite = Colors.indigo[100];

  static List<Color> tileColors = [
    Colors.indigo[50],
    Colors.blue[50],
    Colors.green[50],
    Colors.amber[50],
    Colors.purple[50],
    Colors.brown[50],
    Colors.green[50],
    Colors.yellow[50],
    Colors.pink[50],
  ];
  static List<Color> tileIconColors = [
    Colors.indigo,
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.green,
    Colors.yellow,
    Colors.pink,
  ];
  static List<Color> cardHeader = [
    Colors.green[100],
    Colors.purple[100],
    Colors.deepOrange[100],
  ];
  static List<BoxShadow> neumorpShadow = [
    BoxShadow(
        color: Colors.black26.withOpacity(.1),
        offset: Offset(1, 1),
        blurRadius: 5)
  ];
}

class AppSlider {
  static List<LinearGradient> gradient = [
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.indigo[600], Colors.purple[300]],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue[600], Colors.blue[300]],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.red[600], Colors.red[300]],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orange[600], Colors.orange[300]],
    )
  ];
  static List<LinearGradient> sliderGradient = [
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.indigo[300], Colors.purple[100]],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.blue[300], Colors.blue[100]],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.red[300], Colors.red[100]],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.orange[300], Colors.orange[100]],
    )
  ];
  static List number = [
    '01',
    '02',
    '03',
    '04',
  ];
  static List text = [
    'Completed',
    'Progress',
    'Start',
    'Done',
  ];
  static List name = [
    'Self Study',
    'Challenges',
    'Report',
    'Profile',
  ];
  static List cardtext = [
    'Introduction To Biology',
    'Further Mathematics',
    'Fundamentals of Chemisty',
  ];
  static List cardimage = [
    'assets/icons/bio.png',
    'assets/icons/maths.png',
    'assets/icons/chem.png',
  ];
  static List subName = [
    'Organic Chemistry',
    'Organic Chemistry',
    'Organic Chemistry',
  ];
  static List testDetail = [
    'You have 40 minutes to answer all 50 questions.',
    'You have 40 minutes to answer all 50 questions.',
    'You have 40 minutes to answer all 50 questions.',
  ];
}

class AppTile {
  static List tileText = [
    'Self Study',
    'Rank Booster Test',
    'My Report',
    'My Cource Content',
    'My Syllabus Progress',
    'My Revision Zone',
    'Dare 2 Do',
    'My Reward',
    'Money Matters',
  ];
  static List tileIcons = [
    'assets/icons/1.png',
    'assets/icons/2.png',
    'assets/icons/3.png',
    'assets/icons/4.png',
    'assets/icons/5.png',
    'assets/icons/6.png',
    'assets/icons/7.png',
    'assets/icons/8.png',
    'assets/icons/9.png',
  ];
}
