import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constant/constant.dart';
import '../../../widgets/componants/custom_alert.dart';
import '../../../widgets/componants/custom_button.dart';

import 'otp_screen.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _mobile = TextEditingController();
  String verificationId;
  String phoneNo;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  // bool _obscureText = true;
  // IconData _iconVisible = Icons.visibility_off;

  // void _toggleObscureText() {
  //   setState(() {
  //     _obscureText = !_obscureText;
  //     if (_obscureText == true) {
  //       _iconVisible = Icons.visibility_off;
  //     } else {
  //       _iconVisible = Icons.visibility;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
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
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.18),
              child: Image.asset(
                logoUrl,
                fit: BoxFit.contain,
                height: 80,
              ),
            ),
            Align(
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.32),
              child: const Text(
                'WELCOME',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            Align(
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.5),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    onEditingComplete: () {
                      if (_formKey.currentState.validate()) {
                        _verifyPhone();
                      }
                    },
                    cursorColor: firstColor,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.left,
                    controller: _mobile,
                    decoration: InputDecoration(
                      prefixText: '+91',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cirRds),
                        borderSide: const BorderSide(),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: 'Mobile Number',
                      alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cirRds),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Mobile cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.6),
              child: SizedBox(
                child: CustomButton(
                  verpad: EdgeInsets.symmetric(vertical: padBtn, horizontal: 30),
                  buttonText: 'Login',
                  brdRds: cirRds,
                  fntSize: 20,
                  fntWgt: FontWeight.w500,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _verifyPhone();
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.98),
              child: const Text(
                'A Smarter way to simplify your Self Study',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPhone() async {
    _otpSentAlertBox(context);
    phoneNo = "+91" + _mobile.text;
    //print(phoneNo);
    // ignore: await_only_futures
    FirebaseAuth _auth = await FirebaseAuth.instance;
    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      //print('Code sent to ' + phoneNo);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OtpScreen(
          verificationId: verificationId,
          mobile: _mobile.text,
        ),
      ));
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            verificationId = verId;
          },
          codeSent: smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            //print(phoneAuthCredential);
          },
          verificationFailed: (Exception exceptio) {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            _signUpToast(exceptio.toString());
            //print('${exceptio.toString()}');
          });
    } catch (e) {
      // print("-------------------------------" + e.toString());
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
