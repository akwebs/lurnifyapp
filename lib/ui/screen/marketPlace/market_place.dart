import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/widgets/componants/custom_alert.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';

import 'product_page.dart';

class MarketPlace extends StatefulWidget {
  const MarketPlace({Key key}) : super(key: key);

  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  Map<String, dynamic> _weeksMonths = Map();
  List _weeks = [];
  List _months = [];
  List _products = [];

  _getMarketPlaces() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
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
    } catch (e) {
      print(e);
    }
  }

  // ignore: unused_field
  Color _backgroundColor = AppColors.tileIconColors[3];
  Color subColor(int i) {
    if (i % 3 == 0) {
      return AppColors.tileIconColors[3];
    } else if (i % 3 == 1) {
      return AppColors.tileIconColors[2];
    } else if (i % 3 == 2) {
      return AppColors.tileIconColors[1];
    }
    return AppColors.tileIconColors[0];
  }

  // ignore: unused_element
  _onSelected(int i) {
    setState(() {
      _backgroundColor = subColor(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getMarketPlaces(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: [
              Positioned.fill(
                top: -Responsive.getPercent(100, ResponsiveSize.HEIGHT, context),
                left: -Responsive.getPercent(50, ResponsiveSize.WIDTH, context),
                right: -Responsive.getPercent(40, ResponsiveSize.WIDTH, context),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 2, offset: Offset(20, 0)),
                    BoxShadow(color: Colors.white12, blurRadius: 0, spreadRadius: -2, offset: Offset(0, 0)),
                  ], shape: BoxShape.circle, gradient: AppSlider.sliderGradient[0]),
                ),
              ),
              Container(
                height: Responsive.getPercent(35, ResponsiveSize.HEIGHT, context),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        top: 50,
                        left: 150,
                        right: -100,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 2, offset: Offset(20, 0)),
                            BoxShadow(color: Colors.white12, blurRadius: 0, spreadRadius: -2, offset: Offset(0, 0)),
                          ], shape: BoxShape.circle, gradient: AppSlider.sliderGradient[0]),
                        ),
                      ),
                      Positioned.fill(
                        top: 50,
                        bottom: 50,
                        left: -300,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 50, spreadRadius: 1, offset: Offset(20, 0)),
                            BoxShadow(color: Colors.white12, blurRadius: 0, spreadRadius: -2, offset: Offset(0, 0)),
                          ], shape: BoxShape.circle, gradient: AppSlider.sliderGradient[0]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      AppBar(
                        iconTheme: IconThemeData(color: whiteColor),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        brightness: Brightness.dark,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset('assets/images/dime.png'),
                                ),
                                Text(
                                  '5000',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned.fill(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: SafeArea(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Text(
                                "REWARDS",
                                style: TextStyle(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.bold, fontSize: Responsive.getPercent(20, ResponsiveSize.WIDTH, context)),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset('assets/images/dime.png'),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset('assets/images/dime.png'),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset('assets/images/dime.png'),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset('assets/images/dime.png'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
                        child: Container(
                            width: Responsive.getPercent(100, ResponsiveSize.WIDTH, context),
                            child: Text(
                              'Badges',
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Purchased',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                            Container(
                              width: Responsive.getPercent(100, ResponsiveSize.WIDTH, context),
                              height: Responsive.getPercent(10, ResponsiveSize.HEIGHT, context),
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 50),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Available',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                            Container(
                              width: Responsive.getPercent(100, ResponsiveSize.WIDTH, context),
                              height: Responsive.getPercent(10, ResponsiveSize.HEIGHT, context),
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset('assets/images/dime.png'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ]);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // ignore: unused_element
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
                  builder: (context) => ProductPage(_weeks[i].toString(), "week"),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 8 / 10,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 1, spreadRadius: 1, offset: Offset(0, 1))]),
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
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
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

  // ignore: unused_element
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
                  builder: (context) => ProductPage(_months[i].toString(), "month"),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 8 / 10,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 1, spreadRadius: 1, offset: Offset(0, 1))]),
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
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
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

  // ignore: unused_element
  Widget _otherProducts() {
    return Container(
        child: GridView.builder(
      itemCount: _products.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 0.70),
      itemBuilder: (context, i) {
        String imageUrl = "";
        if (_products[i]['status'] == "locked") {
          imageUrl = baseUrl + _products[i]['disableDirectory'] + "/" + _products[i]['disableFileName'];
        } else if (_products[i]['status'] == "active") {
          imageUrl = baseUrl + _products[i]['activeDirectory'] + "/" + _products[i]['activeFileName'];
        } else if (_products[i]['status'] == "purchased") {
          imageUrl = baseUrl + _products[i]['purchasedDirectory'] + "/" + _products[i]['purchasedFileName'];
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
                  _products[i]['referralCode'] == null ? "" : "Referral Code : " + _products[i]['referralCode'],
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
                              Clipboard.setData(new ClipboardData(text: _products[i]['referralCode'])).then((_) {
                                // ignore: deprecated_member_use
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Referral Coupon copied to clipboard")));
                              });
                            },
                          )
                        // ignore: deprecated_member_use
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
