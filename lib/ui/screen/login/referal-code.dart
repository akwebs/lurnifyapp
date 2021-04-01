import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/Animation/FadeAnimation.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/home-page.dart';
import 'package:lurnify/widgets/componants/custom-alert.dart';
import 'package:lurnify/widgets/componants/custom-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReferalCode extends StatefulWidget {
  @override
  _ReferalCodeState createState() => _ReferalCodeState();
}

class _ReferalCodeState extends State<ReferalCode> {
  TextEditingController _referalCode;

  @override
  void initState() {
    _referalCode = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Referral Code"),
        centerTitle: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeAnimation(
                    1.8,
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Form(
                        child: Theme(
                          data: new ThemeData(
                            primaryColor: Colors.deepPurple,
                            primaryColorDark: Colors.black,
                          ),
                          child: TextFormField(
                            cursorColor: firstColor,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                            controller: _referalCode,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: BorderSide(),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: 'Enter Referral Code',
                              labelStyle: TextStyle(color: Colors.black54),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                FadeAnimation(
                  2,
                  SizedBox(
                      width: double.maxFinite,
                      child: CustomButton(
                        verpad: EdgeInsets.symmetric(vertical: 20),
                        buttonText: 'Submit',
                        onPressed: () {
                          _saveReferalCode();
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoButton(
                    child: Text(
                      "Skip",
                      style: TextStyle(color: firstColor),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()),
                          ModalRoute.withName('/'));
                    })
              ],
            ),
          )),
    );
  }

  _saveReferalCode() async {
    if (_referalCode.text.length < 1) {
      _signUpToast("Referral code can not be empty");
    } else {
      _otpSentAlertBox(context);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl +
          "updateReferralCode?registerSno=" +
          sp.getString("studentSno") +
          "&referralCode=" +
          _referalCode.text;
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      Map<String, dynamic> resbody = jsonDecode(response.body);
      if (resbody['result'] == true) {
        _signUpToast(resbody['message']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('/'));
      } else {
        _signUpToast(resbody['message']);
        Navigator.of(context).pop();
      }
      // Navigator.of(context).pop();
    }
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

  void _signUpToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 18.0);
  }
}
