import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/helper/db_helper.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SpinnerClass extends StatefulWidget {
  final _spinData;

  const SpinnerClass(this._spinData, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SpinnerClassState createState() => _SpinnerClassState(_spinData);
}

class _SpinnerClassState extends State<SpinnerClass> {
  final _spinData;
  _SpinnerClassState(this._spinData);
  int _selected = 0;
  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;
  final StreamController _dividerController = StreamController<int>();

  final _wheelNotifier = StreamController<double>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.close),
      ),
      [
        "W 4".text.xl.make(),
        "Challange of day 3".text.make(),
        SpinningWheel(
          Image.asset('assets/images/spinner_01.png'),
          secondaryImage: Image.asset('assets/icons/spineer.png', fit: BoxFit.contain),
          secondaryImageHeight: 60,
          secondaryImageWidth: 60,
          width: 260,
          height: 260,
          initialSpinAngle: _generateRandomAngle(),
          spinResistance: 0.2,
          dividers: 6,
          //shouldStartOrStop: _wheelNotifier.stream,
          onUpdate: _dividerController.add,
          onEnd: _dividerController.add,
        ).p12().centered().pOnly(bottom: 20).onTap(() {
          _wheelNotifier.sink.add(_generateRandomVelocity());
        }),
        'How to paly'.text.make(),
        VxBox(
          child: const Divider(
            height: 10,
            thickness: 1,
            indent: 0,
            endIndent: 20,
          ),
        ).make().py8(),
        'Terms & Conditions'.text.make().pOnly(bottom: 20),
        50.heightBox,
      ].vStack(crossAlignment: CrossAxisAlignment.start).px8().py12(),
    ].zStack(alignment: Alignment.topRight);
    // return FortuneWheel(
    //   indicators: [
    //     FortuneIndicator(
    //         child: Image.asset(
    //           'assets/icons/spineer.png',
    //           fit: BoxFit.contain,
    //           height: 60,
    //         ).onTap(() {
    //           try {
    //             print(_selected);
    //             var _random = Random();
    //             setState(() {
    //               _selected = _random.nextInt(6);
    //               print(_selected);
    //             });
    //           } catch (e) {
    //             print(e);
    //           }
    //         }),
    //         alignment: Alignment.center)
    //   ],
    //   physics: CircularPanPhysics(
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.decelerate,
    //   ),

    //   duration: const Duration(seconds: 10),
    //   animateFirst: false,
    //   selected: _selected,
    //   onAnimationEnd: () {
    //     _updateDailyTask();
    //   },
    //   items: List.generate(
    //     _spinData.length,
    //     (index) {
    //       return FortuneItem(
    //           style: FortuneItemStyle(
    //               color: AppColors.tileIconColors[index],
    //               textStyle: const TextStyle(
    //                 color: Colors.white,
    //               ),
    //               textAlign: TextAlign.center),
    //           child: Text(_spinData[index]['taskName']));
    //     },
    //   ),
    // );
  }

  _updateDailyTask() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +
      //     "storeSpinData?registerSno=" +
      //     sp.getString("studentSno") +
      //     "&dailyTaskSno=" +
      //     _spinData[_selected - 1]['sno'].toString();
      // print(url);
      // http.Response response = await http.post(
      //   Uri.encodeFull(url),
      // );
      DBHelper dbHelper = DBHelper();
      Database database = await dbHelper.database;
      String sql = "select sno from daily_task_completion "
          "where registerSno='${sp.getString("studentSno")}' and spinDate='${DateTime.now().toString().split(" ")[0]}' ";
      List<Map<String, dynamic>> list = await database.rawQuery(sql);
      print("-----------------------------------$list");
      if (list.isEmpty) {
        String sql2 = "insert into daily_task_completion (registerSno,dailyTaskSno,spinDate,status,enteredDate,onlineStatus) "
            "values('${sp.getString("studentSno")}','${_spinData[_selected - 1]['sno'].toString()}',"
            "'${DateTime.now().toString().split(" ")[0]}',"
            "'spined','${DateTime.now().toString()}','new')";
        print(sql2);
        await database.rawInsert(sql2);
      } else {
        String sql2 =
            "update daily_task_completion set dailyTaskSno='${_spinData[_selected - 1]['sno'].toString()}', status='spined', onlineStatus='new' where registerSno='${sp.getString("studentSno")}' "
            "and spinDate='${DateTime.now().toString().split(" ")[0]}'";
        print(sql2);
        await database.rawUpdate(sql2);
      }

      // String s="select * from daily_task_completion";
      // var a = await database.rawQuery(s);
      // print(a);

      _showSpinTask();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showSpinTask() async {
    String result = "";
    List<Map<String, dynamic>> data = _spinData[_selected - 1]['dailyTaskDatas'];
    for (int i = 0; i < data.length; i++) {
      result = result +
          "Your task type is" +
          data[i]['taskType'] +
          " and you have to complete " +
          data[i]['taskUnit'].toString() +
          "test or study minute\nAnd you will be rewarded with " +
          data[i]['coins'].toString() +
          " Coins or " +
          data[i]['cash'].toString() +
          " cash or " +
          data[i]['certificate'].toString() +
          " certificates or " +
          data[i]['noOfReferralCoupons'].toString() +
          " refferals coupons\n";
    }
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Congratulations',
      desc: result,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkColor: Colors.black87,
      btnOkText: "Great",
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    )..show();
  }
}
