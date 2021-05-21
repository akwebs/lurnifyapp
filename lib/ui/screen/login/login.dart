import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/Animation/FadeAnimation.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/login/OtpScreen.dart';
import 'package:lurnify/widgets/componants/custom-alert.dart';
import 'package:lurnify/widgets/componants/custom-button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _mobile = TextEditingController();
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            width: Responsive.getPercent(100, ResponsiveSize.WIDTH, context),
            height: Responsive.getPercent(50, ResponsiveSize.HEIGHT, context),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/login/background.png',
                    ),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 30,
            width: 80,
            height: 200,
            child: FadeAnimation(
                1,
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login/light-1.png'),
                    ),
                  ),
                )),
          ),
          Positioned(
            left: 140,
            width: 80,
            height: 150,
            child: FadeAnimation(
                1.3,
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login/light-2.png'),
                    ),
                  ),
                )),
          ),
          Positioned(
            right: 0,
            top: 0,
            width: 150,
            height: 150,
            child: FadeAnimation(
              1.5,
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/login/clock.png'),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                      1.4,
                      Container(
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                      1.8,
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              cursorColor: firstColor,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: TextStyle(
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.center,
                              controller: _mobile,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: 'Mobile Number',
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Mobile cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                      2,
                      SizedBox(
                          width: double.maxFinite,
                          child: CustomButton(
                            verpad: EdgeInsets.symmetric(vertical: 20),
                            buttonText: 'Login',
                            brdRds: 10,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _verifyPhone();
                              }
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPhone() async {
    _otpSentAlertBox(context);
    this.phoneNo = "+91" + _mobile.text;
    print(this.phoneNo);
    // ignore: await_only_futures
    FirebaseAuth _auth = await FirebaseAuth.instance;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print('Code sent to ' + this.phoneNo);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OtpScreen(
          verificationId: this.verificationId,
          mobile: _mobile.text,
        ),
      ));
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (Exception exceptio) {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            _signUpToast(exceptio.toString());
            print('${exceptio.toString()}');
          });
    } catch (e) {
      print("-------------------------------" + e.toString());
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
