import 'package:flutter/material.dart';


class CustomAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          SizedBox(width: 20,),
          Text("Please Wait...")
        ],
      ),
    );
  }
}
