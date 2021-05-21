import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/widget/custom-alert.dart';
import 'package:lurnify/ui/screen/widget/custom-button.dart';


class PurchasedItem extends StatefulWidget {
  @override
  _PurchasedItemState createState() => _PurchasedItemState();
}

class _PurchasedItemState extends State<PurchasedItem> {

  List _purchasedItems=[];

  _getPurchasedItems()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url=baseUrl+"getPurchasedItems?registerSno="+sp.getString("studentSno");
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    _purchasedItems = jsonDecode(response.body);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchased Items"),
      ),
      body: FutureBuilder(
        future: _getPurchasedItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return _purchasedItems.isEmpty?Container(
              child: Center(
                child: Text("No Data",style: TextStyle(fontSize: 50,fontWeight: FontWeight.w600,color: Colors.grey),),
              ),
            ):Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: _purchasedItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.5,
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5
                ),
                itemBuilder: (context,i){
                 return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInImage(
                            placeholder: AssetImage("assets/images/dime.png"),
                            //HERE COULD BE THE MISTAKE. I CHNAGE IMAGEURL WITH BASE URL
                            image: NetworkImage(baseUrl+_purchasedItems[i]['purchasedDirectory']+"/"+_purchasedItems[i]['purchasedFileName']),
                            fit: BoxFit.fill,
                            height: 100,
                          ),
                          SizedBox(height: 5,),
                          Text(_purchasedItems[i]['price'].toStringAsFixed(0)+" Coins",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                          SizedBox(height: 5,),
                          Text(_purchasedItems[i]['productName'].toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                          SizedBox(height: 5,),
                          Text(_purchasedItems[i]['description'].toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
                          SizedBox(height: 5,),
                          Text(_purchasedItems[i]['referralCode']==null?"":"Referral Code : "+_purchasedItems[i]['referralCode'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                          SizedBox(height: 5,),
                          _purchasedItems[i]['referalUsed']==true?Row(
                            children: [
                              Icon(Icons.done,color: Colors.green,),
                              Text("Used by your friend")
                            ],
                          ):Container(),
                          _purchasedItems[i]['referralPaymentDone']==true?Row(
                            children: [
                              Icon(Icons.done,color: Colors.green,),
                              Text("Used by your friend")
                            ],
                          ):Container(),
                          _purchasedItems[i]['referalUsed']==false && _purchasedItems[i]['referralPaymentDone']==false ? Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  buttonText: "Apply",
                                  onPressed: (){
                                      _applyForRedemption(_purchasedItems[i]['referralCode']);
                                  },
                                ),
                              )
                            ],
                          ):Container(),
                          SizedBox(height: 5,),
                          _purchasedItems[i]['referralCode']!=null?CustomButton(
                            buttonText: "Copy",
                            onPressed: (){
                              Clipboard.setData(new ClipboardData(text: _purchasedItems[i]['referralCode'])).then((_){
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content:Text("Referral Coupon copied to clipboard")));
                              });
                            },
                          ): Container()
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
      ),
    );
  }

  _applyForRedemption(referralCode)async{
    _otpSentAlertBox(context);
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url=baseUrl+"applyForRedemption?registerSno="+sp.getString("studentSno")+"&referralCode="+referralCode;
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    Map<String, dynamic> map = jsonDecode(response.body);
    if(map['result']==true){
      toastMethod("Applied for redemption. you will receive your money in 4 working days");
    }else{
      toastMethod("Sorry you are not eligible for redemption");
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
