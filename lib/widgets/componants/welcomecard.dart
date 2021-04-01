import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: Responsive.getPercent(30, ResponsiveSize.HEIGHT, context),
        decoration: BoxDecoration(
          boxShadow: NewappColors.neumorpShadow,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          'assets/images/card.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
