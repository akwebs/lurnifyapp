import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(firstColor),
          ),
          const SizedBox(
            width: 20,
          ),
          const Text("Please Wait...")
        ],
      ),
    );
  }
}
