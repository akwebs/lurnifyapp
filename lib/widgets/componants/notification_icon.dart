import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class CustomNotificationIcon extends StatelessWidget {
  const CustomNotificationIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.getPercent(13, ResponsiveSize.WIDTH, context),
      height: Responsive.getPercent(13, ResponsiveSize.WIDTH, context),
      decoration: BoxDecoration(
          color: NewappColors.onprimaryColor,
          boxShadow: NewappColors.neumorpShadow,
          shape: BoxShape.circle),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: NewappColors.primaryColor,
                  boxShadow: NewappColors.neumorpShadow,
                  shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(11),
              decoration: BoxDecoration(shape: BoxShape.circle),
            ),
          ),
          Center(
            child: IconButton(
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    color: NewappColors.onprimaryColor,
                  ),
                  Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: new Icon(Icons.brightness_1,
                        size: 10.0, color: Colors.red),
                  )
                ],
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text(
                          'Notifications',
                        ),
                      ),
                      body: const Center(
                        child: Text(
                          'This is the Notification Page',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
