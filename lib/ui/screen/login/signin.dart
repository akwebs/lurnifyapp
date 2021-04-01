import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        // top blue background gradient
        Container(
          height: MediaQuery.of(context).size.height / 3.5,
          decoration: BoxDecoration(gradient: AppSlider.gradient[0]),
        ),
        // set your logo here
        Container(
            margin: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height / 20, 0, 0),
            alignment: Alignment.topCenter,
            child: Image.asset('assets/images/logo_dark.png', height: 120)),
        ListView(
          children: <Widget>[
            // create form login
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              margin: EdgeInsets.fromLTRB(
                  32, MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
              color: Colors.white,
              child: Container(
                  margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[600])),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[600])),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          suffixIcon: IconButton(
                              icon: Icon(_iconVisible,
                                  color: Colors.grey[700], size: 20),
                              onPressed: () {
                                _toggleObscureText();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Click forgot password',
                                toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                    Colors.deepPurple,
                              ),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  home_page, (route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            // create sign up link
            Center(
              child: Wrap(
                children: <Widget>[
                  Text('New User? '),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Click signup', toastLength: Toast.LENGTH_SHORT);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )
      ],
    ));
  }
}
