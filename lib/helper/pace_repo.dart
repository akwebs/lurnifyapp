import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/pace.dart';
import 'package:sqflite/sqflite.dart';

class PaceRepo {
  DBHelper dbHelper = DBHelper();

  insertIntoPace(Pace pace) async {
    try {
      Database db = await dbHelper.database;
      // String sql ="select * from pace";
      // List<Map<String,dynamic>> list=await db.rawQuery(sql);
      // if(list.isEmpty){
      //
      // }else{
      //
      // }
      db.insert('pace', pace.toJson());
    } catch (e) {
      //print('insertIntoPace : ' + e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getPace() async {
    Database db = await dbHelper.database;
    String sql = "select * from pace";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }
}
