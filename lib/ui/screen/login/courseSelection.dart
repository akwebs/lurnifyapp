import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/Animation/FadeAnimation.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/login/referal-code.dart';
import 'package:lurnify/widgets/componants/custom-alert.dart';
import 'package:lurnify/widgets/componants/custom-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseSelection extends StatefulWidget {
  final mobile;
  CourseSelection(this.mobile);
  @override
  _CourseSelectionState createState() => _CourseSelectionState(mobile);
}

class _CourseSelectionState extends State<CourseSelection> {
  String mobile;
  _CourseSelectionState(this.mobile);

  var data;
  List courseList = [];
  int selectedIndex;
  int selectedCourseSno = 0;
  Future getCourse() async {
    try {
      var url = baseUrl + "getCourses";
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      print(resbody);
      courseList = resbody;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    data = getCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses For Enrollment"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  getCourse();
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 150,
                        child: ListView.builder(
                          itemCount: courseList.length,
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = i;
                                  selectedCourseSno = courseList[i]['sno'];
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: selectedIndex == i
                                          ? Border.all(
                                              color: firstColor, width: 2)
                                          : Border.all(
                                              color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(25),
                                      color: firstColor.withOpacity(0.1)),
                                  child: Center(
                                      child: Text(
                                    courseList[i]['courseName'],
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800),
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      FadeAnimation(
                        1.2,
                        SizedBox(
                          width: Responsive.getPercent(
                              80, ResponsiveSize.WIDTH, context),
                          child: CustomButton(
                            verpad: EdgeInsets.symmetric(vertical: 20),
                            buttonText: 'Start',
                            onPressed: () {
                              _start();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future _start() async {
    try {
      if (selectedCourseSno == 0) {
        toastMethod("Please Select Course");
      } else {
        _otpSentAlertBox(context);
        SharedPreferences sp = await SharedPreferences.getInstance();
        var url = baseUrl +
            "saveRegistration?accountType=1&course=" +
            selectedCourseSno.toString() +
            "&mobile=" +
            mobile.toString();
        http.Response response = await http.post(
          Uri.encodeFull(url),
        );
        print(url);
        var resbody = jsonDecode(response.body);
        print(resbody);
        Map recentData = resbody;
        Navigator.of(context).pop();
        if (recentData['sno'] > 0) {
          sp.setString("mobile", mobile.toString());
          sp.setString("courseSno", selectedCourseSno.toString());
          sp.setString("studentSno", recentData['sno'].toString());
          toastMethod("Registration Successful");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ReferalCode()));
        } else {
          toastMethod("Registration Failed");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  _otpSentAlertBox(BuildContext context) {
    var alert = CustomAlert();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
