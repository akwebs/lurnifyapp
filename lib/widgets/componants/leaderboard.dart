import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: Responsive.getPercent(10, ResponsiveSize.HEIGHT, context),
        decoration: BoxDecoration(
          boxShadow: NewappColors.neumorpShadow,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.indigo[300], Colors.purple[100]],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Points',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              ':',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(
              '2586',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
