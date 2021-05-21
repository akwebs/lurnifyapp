import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  double brdRds = 10;
  final verpad;
  CustomButton({this.buttonText, this.onPressed, this.verpad, this.brdRds});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) => 3.0,
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => Colors.deepPurple,
          ),
          overlayColor: MaterialStateProperty.all(Colors.black26),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(brdRds),
          )),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: verpad,
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
