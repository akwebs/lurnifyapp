import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/widgets/componants/custom_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/marketPlace/product_page.dart';

class WeekMonth extends StatefulWidget {
  @override
  _WeekMonthState createState() => _WeekMonthState();
}

class _WeekMonthState extends State<WeekMonth> {
  Map<String, dynamic> _weeksMonths = Map();
  List _weeks = [];
  List _months = [];
  List _products = [];
  String _totalDimes = "0";

  _getWeekMonths() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url1 = baseUrl + "getHomePageData?registerSno=" + sp.getString("studentSno");
      print(url1);
      http.Response response1 = await http.post(
        Uri.encodeFull(url1),
      );
      var resbody1 = jsonDecode(response1.body);

      _totalDimes = resbody1['totalDimes'].toString();
      var url = baseUrl + "getWeekAndMonth?registerSno=" + sp.getString("studentSno");
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

      print(_totalDimes);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getWeekMonths(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: Container(
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: Text("Market place"),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: _totalDimes != null
                              ? Row(
                                  children: [
                                    Text(
                                      _totalDimes,
                                      style: TextStyle(color: firstColor, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.monetization_on_rounded,
                                      size: 18,
                                    )
                                  ],
                                )
                              : Container(
                                  child: Text(''),
                                ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue[100].withOpacity(0.1), Colors.deepPurple[100].withOpacity(0.1)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _weekCards(),
                      _monthCards(),
                      Container(
                        width: MediaQuery.of(context).size.width * 8 / 10,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Text(
                          "Other Products",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          width: 1,
                        ))),
                      ),
                      _otherProducts()
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue[100].withOpacity(0.1), Colors.deepPurple[100].withOpacity(0.1)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ));
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _weekCards() {
    return AspectRatio(
      aspectRatio: 4 / 1.5,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _weeks.length,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductPage(_weeks[i].toString(), "week"),
                ));
              },
              child: AspectRatio(
                aspectRatio: 3 / 2.5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Card(
                    elevation: 6,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      _weeks[i].toString(),
                                      style: TextStyle(shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ], color: whiteColor, fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/icons/calender.png'))),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Week ' + _weeks[i].toString(),
                                    style: TextStyle(shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ], color: whiteColor, fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: whiteColor,
                                    size: 14,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromRGBO(72, 214, 202, 0.8), Color.fromRGBO(82, 28, 234, 0.8)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _monthCards() {
    return AspectRatio(
      aspectRatio: 4 / 1.5,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _months.length,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductPage(_months[i].toString(), "month"),
                ));
              },
              child: AspectRatio(
                aspectRatio: 3 / 1.3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Card(
                    elevation: 6,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      _months[i].toString(),
                                      style: TextStyle(shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ], color: whiteColor, fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/icons/calender.png'))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text(
                                  'You are just one step away',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Month',
                                    style: TextStyle(
                                        //   shadows: <Shadow>[
                                        //   Shadow(
                                        //     offset: Offset(2.0, 2.0),
                                        //     blurRadius: 3.0,
                                        //     color: Colors.black.withOpacity(0.2),
                                        //   ),
                                        // ],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg-1.png'), fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _otherProducts() {
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
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
              imageUrl = baseUrl + _products[i]['disableDirectory'] + "/" + _products[i]['disableFileName'];
            } else if (_products[i]['status'] == "active") {
              imageUrl = baseUrl + _products[i]['activeDirectory'] + "/" + _products[i]['activeFileName'];
            } else {
              imageUrl = baseUrl + _products[i]['purchasedDirectory'] + "/" + _products[i]['purchasedFileName'];
            }
            print("--------------------------------------------------");
            print(imageUrl);
            double price = _products[i]['price'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                placeholder: AssetImage("assets/images/dime.png"),
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
                                      _products[i]['productName'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
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
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg-1.png'), fit: BoxFit.cover)),
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
            // ignore: deprecated_member_use
            new FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(false); // dismisses only the dialog and returns false
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true); // dismisses only the dialog and returns true
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
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black87, textColor: Colors.white, fontSize: 18.0);
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
