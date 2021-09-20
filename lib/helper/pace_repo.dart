import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/pace.dart';
import 'package:sqflite/sqflite.dart';

class PaceRepo {
  DBHelper dbHelper = DBHelper();

  Future<int> insertIntoPace(Pace pace) async {
    int sno=0;
    try {
      Database db = await dbHelper.database;
      // String sql ="select * from pace";
      // List<Map<String,dynamic>> list=await db.rawQuery(sql);
      // if(list.isEmpty){
      //
      // }else{
      //
      // }
      sno=await db.insert('pace', pace.toJson());
    } catch (e) {
      //print('insertIntoPace : ' + e.toString());
    }
    return sno;
  }

  Future<List<Map<String, dynamic>>> getPace() async {
    Database db = await dbHelper.database;
    String sql = "select * from pace";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }
}
