import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/constant.dart';

// ignore: must_be_immutable
class CustomInput extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  var validation;
  var val;
  final String hintText;
  final TextInputType keyboardType;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  CustomInput(
      {this.errorMessage,
      this.hintText,
      this.controller,
      this.keyboardType,
      this.validation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .2),
                blurRadius: 20.0,
                offset: Offset(0, 10))
          ]),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            cursorColor: firstColor,
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            validator: (val) {
              if (validation) {
                return errorMessage;
              } else {
                return null;
              }
            },
            keyboardType: keyboardType,
          ),
        ),
      ),
    );
  }
}
