import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  double brdRds = 10;
  final verpad;
  Color btnClr;
  IconData icon;
  double fntSize;
  FontWeight fntWgt;
  CustomButton(
      {this.buttonText,
      this.onPressed,
      this.verpad,
      this.brdRds,
      this.btnClr,
      this.icon,
      this.fntSize,
      this.fntWgt});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
              (Set<MaterialState> states) =>
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) => 3.0,
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => btnClr == null ? firstColor : btnClr,
          ),
          overlayColor: MaterialStateProperty.all(Colors.black26),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(brdRds == null ? 10 : brdRds),
          )),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: verpad == null ? EdgeInsets.symmetric(vertical: 10) : verpad,
          child: buttonText != null
              ? Text(
                  buttonText,
                  style: TextStyle(
                      fontWeight: fntWgt == null ? FontWeight.normal : fntWgt,
                      fontSize: fntSize == null ? 16 : fntSize,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )
              : Icon(
                  icon,
                  color: whiteColor,
                ),
        ));
  }
}
