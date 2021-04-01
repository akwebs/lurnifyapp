import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class UserPic extends StatelessWidget {
  const UserPic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/anshul.png'),
      ),
      decoration: new BoxDecoration(
        boxShadow: NewappColors.neumorpShadow,
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.deepPurple,
          width: 2.0,
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Anil Jangid'),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                size: 12,
              ),
              Text(
                'Kota, Rajasthan',
                style: TextStyle(fontSize: 10),
              ),
            ],
          )
        ],
      ),
    );
  }
}
