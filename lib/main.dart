import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/ui/library/flutter_overboard/onboarding/on-boarding.dart';
import 'package:lurnify/ui/screen/login/login.dart';
import 'package:lurnify/ui/screen/selfstudy/selectpace.dart';
import 'package:lurnify/ui/screen/selfstudy/selfstudy.dart';
import 'package:lurnify/ui/splash_screen.dart';
import 'package:lurnify/ui/theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() {
    print("completed");
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
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
      home: SplashScreenPage(),
      routes: <String, WidgetBuilder>{
        splash_screen: (BuildContext context) => SplashScreenPage(),
        on_boarding: (BuildContext context) => Onboarding1Page(),
        home_page: (BuildContext context) => HomePage(),
        self_study: (BuildContext context) => SelfStudySection(),
        select_pace: (BuildContext context) => SelectThePace(),
        Log_in: (BuildContext context) => Login(),
      },
      initialRoute: splash_screen,
    );
  }
}
