import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/widget/custom-alert.dart';
import 'package:lurnify/ui/screen/widget/custom-button.dart';

class ProductPage extends StatefulWidget {
  final String weekOrMonthSno;
  final String weekOrMonth;
  ProductPage(this.weekOrMonthSno,this.weekOrMonth);

  @override
  _ProductPageState createState() => _ProductPageState(weekOrMonthSno,weekOrMonth);
}

class _ProductPageState extends State<ProductPage> {
  final String weekOrMonthSno;
  final String weekOrMonth;
  _ProductPageState(this.weekOrMonthSno,this.weekOrMonth);

  List _products=[];
  _getProducts()async{
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url="";
      if(weekOrMonth=="week"){
        url=baseUrl+"getProductsByWeek?registerSno="+sp.getString("studentSno")+"&week="+weekOrMonthSno;
      }else if(weekOrMonth=="month"){
        url=baseUrl+"getProductsByMonth?registerSno="+sp.getString("studentSno")+"&month="+weekOrMonthSno;
      }

      print(url);
      http.Response response = await http.get(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      _products=resbody;
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: FutureBuilder(
        future: _getProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return _products.isEmpty?Container(
              alignment: Alignment.center,
              child: Text("No Products",style: TextStyle(color: Colors.grey,fontSize: 40,fontWeight: FontWeight.w600),),
            ):Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: _products.length,
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.70
                ),
                itemBuilder: (context,i){
                  String imageUrl="";
                  if(_products[i]['status']=="locked"){
                    //HERE COULD BE THE MISTAKE. I CHNAGE IMAGEURL WITH BASE URL
                    imageUrl=baseUrl+_products[i]['disableDirectory']+"/"+_products[i]['disableFileName'];
                  }else if(_products[i]['status']=="active"){
                    imageUrl=baseUrl+_products[i]['activeDirectory']+"/"+_products[i]['activeFileName'];
                  }
                  print(imageUrl);
                  double price=_products[i]['price'];
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
                          SizedBox(height: 5,),
                          Text(price.toStringAsFixed(0)+" Coins",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                          SizedBox(height: 5,),
                          Text(_products[i]['productName'].toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                          SizedBox(height: 5,),
                          Text(_products[i]['description'].toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
                          SizedBox(height: 5,),
                          _products[i]['status']=="locked" ?
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey)
                                ),
                                child:Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock),
                                    Text("Locked")
                                  ],
                                ),
                                onPressed: (){
                                  _alertBoxReceivePayment(i);
                                },
                              ):
                          CustomButton(
                            buttonText: "BUY",
                            onPressed: (){
                              _alertBoxReceivePayment(i);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }


  _alertBoxReceivePayment(i)async{
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
              child: Text('No',style: TextStyle(color: Colors.black),),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true); // dismisses only the dialog and returns true
                _buyProduct(i);
              },
              child: Text('Yes',style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

  _buyProduct(i)async{
    try{
      _otpSentAlertBox(context);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url=baseUrl+"buyProduct?registerSno="+sp.getString("studentSno")+"&productSno="
          +_products[i]['sno'].toString()+"&price="+_products[i]['price'].toStringAsFixed(0)+"&productName="+_products[i]['productName'];
      print(url);
      http.Response response = await http.post(
        Uri.encodeFull(url),
      );
      var resbody = jsonDecode(response.body);
      Map<String,dynamic> result=resbody;
      if(result['result']=="true"){
        _toast("Congratulations! Your purchase confirmed");
        setState(() {

        });
      }else if(result['result']=="lowBalance"){
        _toast("Your balance is low.");
      }else{
        _toast("Failed. Please try again.");
      }
    }catch(e){
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
