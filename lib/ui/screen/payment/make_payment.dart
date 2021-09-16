import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/widgets/componants/custom_alert.dart';
import 'package:lurnify/widgets/componants/custom_expantion_tile.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class MakePayment extends StatefulWidget {
  final bool _isPaymentDone;

  MakePayment(this._isPaymentDone);

  @override
  _MakePaymentState createState() => _MakePaymentState(_isPaymentDone);
}

class _MakePaymentState extends State<MakePayment> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  final bool _isPaymentDone;

  _MakePaymentState(this._isPaymentDone);

  List _payment = [];
  String _totalAmount = "";
  String _discountedAmount = "";
  String validTill = "";
  String dateWithoutT = "";
  String _courseName = "";
  String _mobile = "";

  _getPayment() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl + "getPaymentByCourse?courseSno=" + sp.getString("courseSno");
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      _payment = jsonDecode(response.body);
      if (_payment.isNotEmpty) {
        _totalAmount = _payment[0]['totalAmount'].toStringAsFixed(0);
        _discountedAmount = _payment[0]['discountedAmount'].toStringAsFixed(0);
        validTill = _payment[0]['validTill'].toString();
        dateWithoutT = validTill.substring(0, 10);
      }

      DBHelper dbHelper = new DBHelper();
      Database database = await dbHelper.database;
      String sql = "select * from course";
      List<Map<String, dynamic>> list = await database.rawQuery(sql);
      for (var a in list) {
        _courseName = a['courseName'];
      }
      _mobile = sp.getString('mobile');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _openCheckout() async {
    var options = {
      'key': 'rzp_live_R1np7eYmGTALYA',
      'amount': 200,
      'name': 'Lurnify',
      'description': _courseName,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': _mobile, 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _makePayment();
    print(
      "SUCCESS: " + response.paymentId,
    );
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
      "ERROR: " + response.code.toString() + " - " + response.message,
    );
    Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message, toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName);
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getPayment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Money Matters"),
                centerTitle: true,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                      child: CustomExpansionTile(
                        childrenPadding: EdgeInsets.all(15),
                        title: Column(
                          children: [
                            Text(
                              'Course Name',
                              style: TextStyle(color: Colors.amberAccent, fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                            Text('Course features & Benefits'),
                          ],
                        ),
                        children: [
                          Text(''),
                        ],
                      ),
                    ),
                    Card(
                      child: CustomExpansionTile(
                        childrenPadding: EdgeInsets.all(15),
                        title: Column(
                          children: [
                            Text(
                              'Program Fee',
                              style: TextStyle(color: Colors.amberAccent, fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\u20B9 $_totalAmount',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Valid Till ' + dateWithoutT,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        children: [
                          Text(''),
                        ],
                      ),
                    ),
                    Card(
                      child: CustomExpansionTile(
                        childrenPadding: EdgeInsets.all(15),
                        title: Column(
                          children: [
                            Text(
                              'Your Earning',
                              style: TextStyle(color: Colors.amberAccent, fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                            Text('Referral Earning & Rewards'),
                          ],
                        ),
                        children: [
                          Text(''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(gradient: AppSlider.gradient[3]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Net Payable Due = \u20B9 $_discountedAmount',
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        btnClr: Colors.orange,
                        brdRds: 50,
                        buttonText: 'Pay \u20B9 $_discountedAmount Now',
                        verpad: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                        onPressed: () {
                          _openCheckout();
                          if (_isPaymentDone) {
                            toastMethod("Payment Already done");
                          } else {}
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        });
  }

  _makePayment() async {
    try {
      _otpSentAlertBox(context);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl + "makePayment?registerSno=" + sp.getString("studentSno");
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result['result'] == true) {
        toastMethod("Payment Successful");
      } else {
        toastMethod("Payment Failed. Please try again");
      }
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pop();
  }

  void toastMethod(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 18.0);
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


// Container(
// padding: EdgeInsets.all(10),
// child: Center(
//   child: Column(
//     mainAxisSize: MainAxisSize.max,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.redAccent.withOpacity(0.4),
//                   blurRadius: 1,
//                   spreadRadius: 1,
//                   offset: Offset(0, 1))
//             ]),
//         child: Text(
//           "\u20B9 $_totalAmount",
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               decoration: TextDecoration.lineThrough),
//         ),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       Container(
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//             color: Colors.green,
//             borderRadius: BorderRadius.circular(40),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.yellow.withOpacity(0.4),
//                   blurRadius: 1,
//                   spreadRadius: 1,
//                   offset: Offset(0, 1))
//             ]),
//         child: Text(
//           "\u20B9 $_discountedAmount",
//           style: TextStyle(color: Colors.white, fontSize: 40),
//         ),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Text(
//             "Valid Till " + validTill,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       // Row(
//       //   children: [
//       //     Expanded(
//       //       child: CustomButton(
//       //         buttonText: "Pay",
//       //         onPressed: () {
//       //           if (_isPaymentDone) {
//       //             toastMethod("Payment Already done");
//       //           } else {
//       //             _makePayment();
//       //           }
//       //         },
//       //       ),
//       //     ),
//       //   ],
//       // )
//     ],
//   ),
// ),
// )