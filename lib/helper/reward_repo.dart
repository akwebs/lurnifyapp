import 'package:lurnify/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class RewardRepo {
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getReward() async {
    Database db = await dbHelper.database;
    String sql = "select * from reward order by sno desc limit 1 ";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }
}
