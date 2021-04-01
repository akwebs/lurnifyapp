import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

class CustomAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(firstColor),
          ),
          SizedBox(
            width: 20,
          ),
          Text("Please Wait...")
        ],
      ),
    );
  }
}
