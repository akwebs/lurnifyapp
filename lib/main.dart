import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/home_page.dart';
import 'package:lurnify/ui/library/flutter_overboard/onboarding/on_boarding.dart';
import 'package:lurnify/ui/screen/screen.dart';
import 'package:lurnify/ui/splash_screen.dart';
import 'package:lurnify/ui/theme.dart';
import 'package:flutter/material.dart';

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
      home: const SplashScreenPage(),
      routes: <String, WidgetBuilder>{
        splashScreen: (BuildContext context) => const SplashScreenPage(),
        onBoarding: (BuildContext context) => const Onboarding1Page(),
        homePage: (BuildContext context) => const HomePage(),
        selfStudy: (BuildContext context) => SelfStudySection(),
        selectPace: (BuildContext context) => const SelectThePace(false),
        logIn: (BuildContext context) => const Login(),
        referralCode: (BuildContext context) => const ReferalCode(),
        courseGroup: (BuildContext context) => const CourseGroup(''),
      },
      initialRoute: splashScreen,
    );
  }
}
