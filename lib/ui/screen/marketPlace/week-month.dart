import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/widget/custom-alert.dart';
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
        elevation: 0,
        title: Text("Market place"),
        centerTitle: true,
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Text(
                        "Other Products",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
      height: 180,
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
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.cardHeader[i], width: 1),
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: MediaQuery.of(context).size.width * 5 / 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.cardTitle[i].withOpacity(0.5),
                              size: 80,
                            )
                            // Image.asset(
                            //   "assets/images/week2.png",
                            // ),
                            ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Week : " + _weeks[i].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg-1.png'),
                          fit: BoxFit.cover)),
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
      height: 100,
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
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.cardHeader[i], width: 1),
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: MediaQuery.of(context).size.width * 8 / 10,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 50,
                          color: AppColors.cardTitle[i],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Text(
                          "Month : " + _months[i].toString(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg-1.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _otherProducts() {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _products.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, i) {
            String imageUrl = "";
            if (_products[i]['status'] == "locked") {
              //HERE COULD BE THE MISTAKE. I CHNAGE IMAGEURL WITH BASE URL
              imageUrl = baseUrl +
                  _products[i]['disableDirectory'] +
                  "/" +
                  _products[i]['disableFileName'];
            } else if (_products[i]['status'] == "active") {
              imageUrl = baseUrl +
                  _products[i]['activeDirectory'] +
                  "/" +
                  _products[i]['activeFileName'];
            } else {
              imageUrl = baseUrl +
                  _products[i]['purchasedDirectory'] +
                  "/" +
                  _products[i]['purchasedFileName'];
            }
            print("--------------------------------------------------");
            print(imageUrl);
            double price = _products[i]['price'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: MediaQuery.of(context).size.height * 2 / 10,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: FadeInImage(
                                placeholder:
                                    AssetImage("assets/images/dime.png"),
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _products[i]['productName']
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _products[i]['description'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  price.toStringAsFixed(0),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Image.asset('assets/images/dime.png'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          color: isDark ? Colors.white : firstColor,
                          icon: (_products[i]['status'] == "locked")
                              ? Icon(Icons.lock_outline_rounded)
                              : (_products[i]['status'] == "purchased")
                                  ? Icon(Icons.check_box_outlined)
                                  : Icon(Icons.shopping_cart_outlined),
                          // _products[i]['status'] == "locked"
                          //     ? Icon(Icons.lock_outline_rounded)
                          //     : Icon(Icons.shopping_cart_outlined),
                          onPressed: (_products[i]['status'] == "locked")
                              ? null
                              : (_products[i]['status'] == "purchased")
                                  ? null
                                  : () {
                                      _alertBoxReceivePayment(i);
                                    },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: CustomButton(
                      //       brdRds: 5,
                      //       verpad:
                      //           EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      //       buttonText: _products[i]['status'] == "locked"
                      //           ? "Locked"
                      //           : "BUY",
                      //       onPressed: _products[i]['status'] == "locked"
                      //           ? null
                      //           : () {
                      //               _alertBoxReceivePayment(i);
                      //             },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg-1.png'),
                          fit: BoxFit.cover)),
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
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => ProductPage(_months[i].toString(), "month"),
        // ));
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
