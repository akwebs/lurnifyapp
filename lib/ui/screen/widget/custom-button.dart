import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  CustomButton({
    this.buttonText,
    this.onPressed
  });


  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(buttonText, style: TextStyle(color: Colors.white),),
      splashColor: Colors.black,
      color: Colors.purpleAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.tealAccent)
      ),
      onPressed: onPressed,
    );
  }
}
