import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/widget/custom-alert.dart';
import 'package:lurnify/ui/screen/widget/custom-button.dart';
import 'package:lurnify/ui/screen/marketPlace/product-page.dart';

class WeekMonth extends StatefulWidget {
  @override
  _WeekMonthState createState() => _WeekMonthState();
}

class _WeekMonthState extends State<WeekMonth> {
  Map<String, dynamic> _weeksMonths = Map();
  List _weeks = [];
  List _months = [];
  List _products = [];

  _getWeekMonths() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url =
          baseUrl + "getWeekAndMonth?registerSno=" + sp.getString("studentSno");
      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      print(resbody);
      _weeksMonths = resbody;
      _weeks = _weeksMonths['weeks'];
      _months = _weeksMonths['months'];
      _products = _weeksMonths['products'];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Market place"),
      ),
      body: FutureBuilder(
        future: _getWeekMonths(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _weekCards(),
                    _monthCards(),
                    Text(
                      "Other Products",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                    ),
                    _otherProducts()
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _weekCards() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _weeks.length,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductPage(_weeks[i].toString(), "week"),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 8 / 10,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 1))
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/week.png",
                      height: 150,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Week : " + _weeks[i].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _monthCards() {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: _months.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductPage(_months[i].toString(), "month"),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 8 / 10,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 1))
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/week.png",
                      height: 150,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Month : " + _months[i].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _otherProducts() {
    return Container(
        child: GridView.builder(
      itemCount: _products.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.70),
      itemBuilder: (context, i) {
        String imageUrl = "";
        if (_products[i]['status'] == "locked") {
          imageUrl = baseUrl +
              _products[i]['disableDirectory'] +
              "/" +
              _products[i]['disableFileName'];
        } else if (_products[i]['status'] == "active") {
          imageUrl = baseUrl +
              _products[i]['activeDirectory'] +
              "/" +
              _products[i]['activeFileName'];
        } else if (_products[i]['status'] == "purchased") {
          imageUrl = baseUrl +
              _products[i]['purchasedDirectory'] +
              "/" +
              _products[i]['purchasedFileName'];
        }
        print(imageUrl);
        double price = _products[i]['price'];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInImage(
                  placeholder: AssetImage("assets/images/dime.png"),
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill,
                  height: 100,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  price.toStringAsFixed(0) + " Coins",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _products[i]['productName'].toString(),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _products[i]['description'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _products[i]['referralCode'] == null
                      ? ""
                      : "Referral Code : " + _products[i]['referralCode'],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                _products[i]['status'] == "active"
                    ? CustomButton(
                        buttonText: "BUY",
                        onPressed: () {
                          _alertBoxReceivePayment(i);
                        },
                      )
                    : _products[i]['referralCode'] != null
                        ? CustomButton(
                            buttonText: "Copy",
                            onPressed: () {
                              Clipboard.setData(new ClipboardData(
                                      text: _products[i]['referralCode']))
                                  .then((_) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Referral Coupon copied to clipboard")));
                              });
                            },
                          )
                        : RaisedButton(
                            child: Text("Purchased"),
                            onPressed: null,
                          )
              ],
            ),
          ),
        );
      },
    ));
  }

  _alertBoxReceivePayment(i) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to buy this product?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(false); // dismisses only the dialog and returns false
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true); // dismisses only the dialog and returns true
                _buyProduct(i);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  _buyProduct(i) async {
    try {
      _otpSentAlertBox(context);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = baseUrl +
          "buyProduct?registerSno=" +
          sp.getString("studentSno") +
          "&productSno=" +
          _products[i]['sno'].toString() +
          "&price=" +
          _products[i]['price'].toStringAsFixed(0) +
          "&productName=" +
          _products[i]['productName'];
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      Map<String, dynamic> result = resbody;
      if (result['result'] == "true") {
        _toast("Congratulations! Your purchase confirmed");
        setState(() {});
      } else if (result['result'] == "lowBalance") {
        _toast("Your balance is low.");
      } else {
        _toast("Failed. Please try again.");
      }
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pop();
  }

  void _toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
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