import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  double brdRds = 10;
  final verpad;
  Color btnClr;
  Color color;
  IconData icon;
  double fntSize;
  FontWeight fntWgt;
  CustomButton({Key key, this.buttonText, this.onPressed, this.verpad, this.brdRds, this.btnClr, this.color, this.icon, this.fntSize, this.fntWgt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((Set<MaterialState> states) => const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) => 3.0,
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => btnClr ?? firstColor,
          ),
          overlayColor: MaterialStateProperty.all(Colors.black26),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(brdRds ?? 10),
          )),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: verpad ?? const EdgeInsets.symmetric(vertical: 10),
          child: buttonText != null
              ? Text(
                  buttonText,
                  style: TextStyle(fontWeight: fntWgt ?? FontWeight.normal, fontSize: fntSize ?? 16, color: color ?? Colors.white),
                  textAlign: TextAlign.center,
                )
              : Icon(
                  icon,
                  color: whiteColor,
                ),
        ));
  }
}
