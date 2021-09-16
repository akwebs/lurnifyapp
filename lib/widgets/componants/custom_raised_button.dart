import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  CustomRaisedButton({this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white),
      ),
      splashColor: Colors.black,
      color: Colors.purpleAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.tealAccent)),
      onPressed: onPressed,
    );
  }
}
