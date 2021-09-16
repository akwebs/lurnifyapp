import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

class MySpinWidget extends StatefulWidget {
  final Function onTap;

  const MySpinWidget({Key key, this.onTap}) : super(key: key);
  @override
  _MySpinWidgetState createState() => _MySpinWidgetState();
}

class _MySpinWidgetState extends State<MySpinWidget>
    with TickerProviderStateMixin {
  bool isTapped = false;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onHighlightChanged: (value) {
            setState(() {
              isTapped = value;
            });
          },
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
            height: isTapped ? 40 : 45,
            width: isTapped ? 150 : 160,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 0,
                  offset: Offset(2, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'SPIN',
                style: TextStyle(color: whiteColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
