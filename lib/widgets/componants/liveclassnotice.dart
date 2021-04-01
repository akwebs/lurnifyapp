import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class LiveClass extends StatelessWidget {
  const LiveClass({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: Responsive.getPercent(10, ResponsiveSize.HEIGHT, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo[600], Colors.purple[300]],
              ),
              boxShadow: NewappColors.neumorpShadow,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Calculas By Sameer Bansal Sir',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Center(
                  child: Row(
                children: [
                  Icon(
                    Icons.brightness_1,
                    color: Colors.red,
                    size: 6,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 1, color: Colors.black12),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                'Join Now',
                style: TextStyle(color: Colors.deepPurple),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
