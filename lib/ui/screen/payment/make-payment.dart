import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/widget/custom-alert.dart';
import 'package:lurnify/ui/screen/widget/custom-button.dart';

import 'package:http/http.dart' as http;

class MakePayment extends StatefulWidget {
  final bool _isPaymentDone;
  MakePayment(this._isPaymentDone);
  @override
  _MakePaymentState createState() => _MakePaymentState(_isPaymentDone);
}

class _MakePaymentState extends State<MakePayment> {
  final bool _isPaymentDone;
  _MakePaymentState(this._isPaymentDone);
  List _payment=[];
  String _totalAmount="";
  String _discountedAmount="";
  String validTill="";
  _getPayment()async{
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url=baseUrl+"getPaymentByCourse?courseSno="+sp.getString("courseSno");
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      _payment = jsonDecode(response.body);
      if(_payment.isNotEmpty){
        _totalAmount=_payment[0]['totalAmount'].toString();
        _discountedAmount=_payment[0]['discountedAmount'].toString();
        validTill=_payment[0]['validTill'].toString();
      }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make payment"),
      ),
      body: FutureBuilder(
        future: _getPayment(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.redAccent.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0,1)
                            )
                          ]
                      ),
                      child: Text("\u20B9 $_totalAmount",style: TextStyle(color: Colors.white,fontSize: 30,decoration: TextDecoration.lineThrough),),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.yellow.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0,1)
                            )
                          ]
                      ),
                      child: Text("\u20B9 $_discountedAmount",style: TextStyle(color: Colors.white,fontSize: 40),),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Valid Till " + validTill,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonText: "Pay",
                            onPressed: (){
                              if(_isPaymentDone){
                                toastMethod("Payment Already done");
                              }else{
                                _makePayment();
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }

  _makePayment()async{
    try{
      _otpSentAlertBox(context);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url=baseUrl+"makePayment?registerSno="+sp.getString("studentSno");
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      Map<String,dynamic> result = jsonDecode(response.body);
      if(result['result']==true){
        toastMethod("Payment Successful");
      }else{
        toastMethod("Payment Failed. Please try again");
      }
    }catch(e){
      print(e);
    }

    Navigator.of(context).pop();
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 18.0);
  }
  _otpSentAlertBox(BuildContext context) {
    var alert = CustomAlert();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
