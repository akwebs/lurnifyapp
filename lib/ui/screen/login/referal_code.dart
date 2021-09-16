import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constant/ApiConstant.dart';
import '../../constant/constant.dart';
import '../selfstudy/select_pace.dart';
import '../../../widgets/componants/custom_alert.dart';
import '../../../widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class ReferalCode extends StatefulWidget {
  const ReferalCode({Key key}) : super(key: key);

  @override
  _ReferalCodeState createState() => _ReferalCodeState();
}

class _ReferalCodeState extends State<ReferalCode> {
  TextEditingController _referalCode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _referalCode = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark, statusBarColor: Colors.transparent),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: Responsive.getPercent(100, ResponsiveSize.WIDTH, context),
                height: Responsive.getPercent(50, ResponsiveSize.HEIGHT, context),
                child: Opacity(
                  opacity: isDark ? 0.3 : 0.5,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/login/background.png',
                          ),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.32),
                child: const Text(
                  'Enter Referral Code',
                  style: TextStyle(fontSize: Vx.dp16, fontWeight: FontWeight.w600),
                ),
              ),
              Align(
                alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.5),
                child: VStack(
                  [
                    const Spacer(),
                    VxBox(
                      child: Form(
                          key: _formKey,
                          child: TextFormField(
                            onEditingComplete: () {
                              if (_formKey.currentState.validate()) {
                                _saveReferalCode();
                              }
                            },
                            cursorColor: firstColor,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            textAlign: TextAlign.left,
                            controller: _referalCode,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(cirRds),
                                  borderSide: const BorderSide(),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Enter Referral Code',
                                alignLabelWithHint: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(cirRds),
                                  borderSide: const BorderSide(),
                                ),
                                floatingLabelStyle: const TextStyle(color: Vx.black)),
                          )),
                    ).make().p16(),
                    TextButton(
                      child: const Text('Skip'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SelectThePace(false),
                        ));
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        verpad: const EdgeInsets.symmetric(vertical: 5),
                        buttonText: "Challange YourSelf Now",
                        brdRds: 0,
                        onPressed: () {
                          _saveReferalCode();
                        },
                      ),
                    )
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _saveReferalCode() async {
    if (_referalCode.text.length < 1) {
      _signUpToast("Referral code can not be empty");
    } else {
      _otpSentAlertBox(context);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl + "updateReferralCode?registerSno=" + sp.getString("studentSno") + "&referralCode=" + _referalCode.text;
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      Map<String, dynamic> resbody = jsonDecode(response.body);
      if (resbody['result'] == true) {
        _signUpToast(resbody['message']);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SelectThePace(false),
        ));
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        //     ModalRoute.withName('/'));
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
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black87, textColor: Colors.white, fontSize: 18.0);
  }
}
