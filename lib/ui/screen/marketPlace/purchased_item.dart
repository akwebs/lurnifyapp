import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/widgets/componants/custom_alert.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:share/share.dart';

import 'week_month.dart';

class PurchasedItem extends StatefulWidget {
  @override
  _PurchasedItemState createState() => _PurchasedItemState();
}

class _PurchasedItemState extends State<PurchasedItem> {
  List _purchasedItems = [];

  // ignore: unused_field
  var _data;
  Map<String, dynamic> resbody = Map();
  String _totalDimes = "0";

  _getPurchasedItems() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl + "getPurchasedItems?registerSno=" + sp.getString("studentSno");
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    _purchasedItems = jsonDecode(response.body);
    var url1 = baseUrl + "getHomePageData?registerSno=" + sp.getString("studentSno");
    print(url1);
    http.Response response1 = await http.post(
      Uri.encodeFull(url1),
    );
    resbody = jsonDecode(response1.body);

    _totalDimes = resbody['totalDimes'].toString();
    print(_totalDimes);
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return FutureBuilder(
      future: _getPurchasedItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: Container(
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: Text("My Rewars & Purchased Items"),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
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
              body: _purchasedItems.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "You did not purchach any product yet.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => WeekMonth()),
                                  );
                                },
                                child: Text('Purchase Now'))
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _purchasedItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.6, crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
                        itemBuilder: (context, i) {
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 2 / 10,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: FadeInImage(
                                            placeholder: AssetImage("assets/images/dime.png"),
                                            image: NetworkImage(baseUrl + _purchasedItems[i]['purchasedDirectory'] + "/" + _purchasedItems[i]['purchasedFileName']),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                _purchasedItems[i]['referralCode'] == null ? "" : 'REFRRAL CODE',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(new ClipboardData(text: _purchasedItems[i]['referralCode'])).then((_) {
                                                    Scaffold.of(context)
                                                        // ignore: deprecated_member_use
                                                        .showSnackBar(SnackBar(content: Text("Referral Coupon copied to clipboard")));
                                                  });
                                                },
                                                child: Text(
                                                  _purchasedItems[i]['referralCode'] == null ? "" : '"' + _purchasedItems[i]['referralCode'] + '"',
                                                  style: TextStyle(
                                                    color: firstColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              _purchasedItems[i]['referalUsed'] == true
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.done,
                                                          color: Colors.green,
                                                        ),
                                                        Text("Used by your friend")
                                                      ],
                                                    )
                                                  : Container(),
                                              _purchasedItems[i]['referralPaymentDone'] == true
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.done,
                                                          color: Colors.green,
                                                        ),
                                                        Text("Used by your friend")
                                                      ],
                                                    )
                                                  : Container(),
                                              Text(
                                                _purchasedItems[i]['description'].toString(),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      color: isDark ? Colors.white : firstColor,
                                      icon: Icon(Icons.share_rounded),
                                      onPressed: () {
                                        Share.share('Hey Check out this cool app, Use this Referral Code "' + _purchasedItems[i]['referralCode'] + '" https://lurnify.in');
                                      },
                                    ),
                                  ),
                                  _purchasedItems[i]['referalUsed'] == true && _purchasedItems[i]['referralPaymentDone'] == true
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: CustomButton(
                                              buttonText: 'APPLY',
                                              verpad: EdgeInsets.symmetric(vertical: 5),
                                              brdRds: 10,
                                              onPressed: () {
                                                _applyForRedemption(_purchasedItems[i]['referralCode']);
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg-1.png'), fit: BoxFit.cover)),
                            ),
                          );
                        },
                      ),
                    ));
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  _applyForRedemption(referralCode) async {
    _otpSentAlertBox(context);
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl + "applyForRedemption?registerSno=" + sp.getString("studentSno") + "&referralCode=" + referralCode;
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    Map<String, dynamic> map = jsonDecode(response.body);
    if (map['result'] == true) {
      toastMethod("Applied for redemption. you will receive your money in 4 working days");
    } else {
      toastMethod("Sorry you are not eligible for redemption");
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
