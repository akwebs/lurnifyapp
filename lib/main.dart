import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/home_page.dart';
import 'package:lurnify/ui/library/flutter_overboard/onboarding/on_boarding.dart';
import 'package:lurnify/ui/screen/dareToDo/dare_to_do.dart';
import 'package:lurnify/ui/screen/marketPlace/market_place.dart';
import 'package:lurnify/ui/screen/marketPlace/purchased_item.dart';
import 'package:lurnify/ui/screen/myCourseContain/course_content.dart';
import 'package:lurnify/ui/screen/myProgress/subject_unit.dart';
import 'package:lurnify/ui/screen/myReport/my_report.dart';
import 'package:lurnify/ui/screen/rankBooster/rank_booster_view.dart';
import 'package:lurnify/ui/splash_screen.dart';
import 'package:lurnify/ui/theme.dart';
import 'package:flutter/material.dart';

import 'ui/screen/login/course_group.dart';
import 'ui/screen/login/login.dart';
import 'ui/screen/login/referal_code.dart';
import 'ui/screen/selfstudy/select_pace.dart';
import 'ui/screen/selfstudy/self_study.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() {
    //print("completed");
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lurnify APP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreenPage(),
      routes: <String, WidgetBuilder>{
        splashScreen: (BuildContext context) => const SplashScreenPage(),
        onBoarding: (BuildContext context) => const Onboarding1Page(),
        homePage: (BuildContext context) => const HomePage(),
        selfStudy: (BuildContext context) => const SelfStudySection(),
        selectPace: (BuildContext context) => const SelectThePace(false),
        logIn: (BuildContext context) => const Login(),
        referralCode: (BuildContext context) => const ReferalCode(),
        courseGroup: (BuildContext context) => const CourseGroup(''),
        rankBooster: (BuildContext context) => RankBoosterHome(),
        myReport: (BuildContext context) => const MyReportHome(),
        courseContent: (BuildContext context) => const MyCourseContent(),
        syllabusProgress: (BuildContext context) => const MyProgress(),
        dareToDo: (BuildContext context) => DareToDo(),
        myReward: (BuildContext context) => PurchasedItem(),
        moneyMatters: (BuildContext context) => const MarketPlace(),
      },
      initialRoute: splashScreen,
    );
  }
}
